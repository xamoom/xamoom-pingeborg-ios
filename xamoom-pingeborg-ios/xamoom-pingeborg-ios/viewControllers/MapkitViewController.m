//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import "MapkitViewController.h"

@interface PingeborgMapView : MKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

@interface MapkitViewController ()

@property bool isUp;
@property UIImage *placeholder;
@property UISwipeGestureRecognizer *swipeGeoFenceViewUp;
@property UISwipeGestureRecognizer *swipeGeoFenceViewDown;
@property UITapGestureRecognizer *geoFenceTapGesture;
@property XMMContentByLocationItem *savedResponseContent;
@property JGProgressHUD *hud;

@end

@implementation MapkitViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  //analytics
  [[Analytics sharedObject] setScreenName:@"Map View"];
  
  self.placeholder = [UIImage imageNamed:@"placeholder"];
  self.isUp = NO;
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];

  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"map_filled"]];

  [self setupTableView];
  [self setupMapView];
  [self setupGeofenceView];
  [self setupLocationManager];
  [self.locationManager startUpdatingLocation];
  
  [self addNotifications];
  
  [self zoomMapToLat:46.623791 andLon:14.308549 andDelta:0.09f];
  
  //check for firstTime geofencing
  if ([[Globals sharedObject] isFirstTimeGeofencing]) {
    self.instructionView.hidden = NO;
  }
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //no location permission
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    [self.geoFenceActivityIndicator stopAnimating];
    self.geoFenceLabel.text = NSLocalizedString(@"No Location", nil);
  }
  
  //create userTracking button
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapKitWithSMCalloutView];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
  
  //load spotmap if there are no annotations on the map
  if (self.mapKitWithSMCalloutView.annotations.count <= 1) {
    [self.geoFenceActivityIndicator startAnimating];
    [self.hud showInView:self.view];
    [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"showAllTheSpots"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                             completion:^(XMMSpotMap *result) {
                                               [self showSpotMap:result];
                                               [self.hud dismissAnimated:YES];
                                             } error:^(XMMError *error) {
                                             }];
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = nil;
  //[self.locationManager stopUpdatingLocation];
}

#pragma mark - Setup

- (void)setupTableView {
  //setting up tableView
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
}

- (void)setupMapView {
  //init map
  self.mapKitWithSMCalloutView = [[PingeborgMapView alloc] initWithFrame:self.view.bounds];
  self.mapKitWithSMCalloutView.delegate = self;
  self.mapKitWithSMCalloutView.showsUserLocation = YES;
  [self.viewForMap addSubview:self.mapKitWithSMCalloutView];
}

- (void)setupGeofenceView {
  //shadow for geoFenceView
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.geofenceView.bounds];
  self.geofenceView.layer.masksToBounds = NO;
  self.geofenceView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.geofenceView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
  self.geofenceView.layer.shadowOpacity = 0.9f;
  self.geofenceView.layer.shadowPath = shadowPath.CGPath;
  
  //create geofence GestureRecognizers
  self.swipeGeoFenceViewUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewUp.direction = UISwipeGestureRecognizerDirectionUp;
  self.swipeGeoFenceViewDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewDown.direction = UISwipeGestureRecognizerDirectionDown;
  self.geoFenceTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
}

- (void)setupLocationManager {
  //init up locationManager
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.locationManager.distanceFilter = 100.0f; //meter
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.activityType = CLActivityTypeOther;
  // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
}

- (void)addNotifications {
  //pingeborg system notifications
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshContentByLocation)
                                               name:@"updateAllArtistLists"
                                             object:nil];
}

#pragma mark - XMMEnduser Methods

- (void)showSpotMap:(XMMSpotMap *)result {
  //get the customMarker for the map
  if (result.style.customMarker != nil) {
    [self mapMarkerFromBase64:result.style.customMarker];
  }
  
  // Add annotations
  for (XMMSpot *item in result.items) {
    XMMAnnotation *point = [[XMMAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake(item.lat, item.lon)];
    point.data = item;
    
    //calculate distance to annotation
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    point.distance = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
    
    [self.mapKitWithSMCalloutView addAnnotation:point];
  }
}

- (void)mapMarkerFromBase64:(NSString*)base64String {
  NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
  NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
  
  if ([decodedString containsString:@"data:image/svg"]) {
    //create svg need to DECODE TWO TIMES!
    decodedString = [decodedString stringByReplacingOccurrencesOfString:@"data:image/svg+xml;base64," withString:@""];
    NSData *decodedData2 = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
    NSString *decodedString2 = [[NSString alloc] initWithData:decodedData2 encoding:NSUTF8StringEncoding];
    self.customSVGMapMarker = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:decodedString2]];
  } else {
    //create UIImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [XMMImageUtility imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
  }
}

- (void)showDataWithLocation:(XMMContentByLocation *)result {
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.imagesToDisplay = [[NSMutableDictionary alloc] init];
  
  //load items in near you, when there is no geofence
  if([result.items count] == 0) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[XMMEnduserApi sharedInstance] closestSpotsWithLat:self.lastLocation.coordinate.latitude withLon:self.lastLocation.coordinate.longitude withRadius:2000 withLimit:10 withLanguage:@""
                                             completion:^(XMMClosestSpot *result) {
                                               [self showClosestSpots:result];
                                             } error:^(XMMError *error) {
                                             }];
    return;
  }
  
  for (XMMContentByLocationItem *item in result.items) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org"
                                           andAction:@"Geofence found"
                                            andLabel:[NSString stringWithFormat:@"User found Geofence at lat: %f lon: %f", self.lastLocation.coordinate.latitude, self.lastLocation.coordinate.longitude]
                                            andValue:nil];
    
    self.savedResponseContent = item;
    [self.itemsToDisplay addObject:item];
    break;
  }
  
  //download image
  [XMMImageUtility imageWithUrl:self.savedResponseContent.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
    if (image != nil) {
      [self.imagesToDisplay setValue:image forKey:self.savedResponseContent.contentId];
    } else if (svgImage != nil) {
      [self.imagesToDisplay setValue:svgImage forKey:self.savedResponseContent.contentId];
    } else {
      [self.imagesToDisplay setValue:self.placeholder forKey:self.savedResponseContent.contentId];
    }
    
    [self geofenceComplete];
    [self.tableView reloadData];
  }];
}

- (void)geofenceComplete {
  //set geoFenceLabel
  self.geoFenceLabel.text = NSLocalizedString(@"Discovered pingeb.org", nil);
  [self enableGeofenceView];
}

- (void)showClosestSpots:(XMMClosestSpot *)result {
  for (XMMSpot *item in result.items) {
    [self.itemsToDisplay addObject:item];
  }
  
  if ([self.itemsToDisplay count] > 0) {
    self.geoFenceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%lu near spots found", nil), (unsigned long)[self.itemsToDisplay count]];
    [self enableGeofenceView];
  } else {
    self.geoFenceLabel.text = NSLocalizedString(@"Nothing found near you", nil);
    [self disableGeofenceView];
  }
}

#pragma mark - MapView Methods

- (void)zoomMapToLat:(double)lat andLon:(double)lon andDelta:(float)delta {
  //map region for zooming
  MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
  region.center.latitude = lat;
  region.center.longitude = lon;
  region.span.longitudeDelta = delta;
  region.span.longitudeDelta = delta;
  [self.mapKitWithSMCalloutView setRegion:region animated:YES];
}

- (XMMCalloutView*)createMapCalloutFrom:(MKAnnotationView *)annotationView {
  XMMAnnotationView* xamoomAnnotationView = (XMMAnnotationView *)annotationView;
  XMMCalloutView* xamoomCalloutView = [[XMMCalloutView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 35.0f)];
  xamoomCalloutView.nameOfSpot = xamoomAnnotationView.data.displayName;
  
  //create titleLabel
  UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 280.0f, 25.0f)];
  titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  titleLabel.numberOfLines = 0;
  titleLabel.text = xamoomAnnotationView.data.displayName;
  
  //size label to fit content
  CGRect titleLabelRect = titleLabel.frame;
  titleLabelRect.size = [titleLabel sizeThatFits:titleLabelRect.size];
  titleLabel.frame = titleLabelRect;
  
  [xamoomCalloutView addSubview:titleLabel];
  
  //increase pingeborCalloutView height
  CGRect xamoomCalloutViewRect = xamoomCalloutView.frame;
  xamoomCalloutViewRect.size.height += titleLabel.frame.size.height;
  xamoomCalloutView.frame = xamoomCalloutViewRect;
  
  //create distance label
  UILabel* distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, titleLabel.frame.size.height + 10.0f, 280.0f, 25.0f)];
  distanceLabel.font = [UIFont systemFontOfSize:12];
  distanceLabel.text = xamoomAnnotationView.distance;
  
  //set coordinates (for navigating)
  xamoomCalloutView.coordinate = xamoomAnnotationView.coordinate;
  
  
  [xamoomCalloutView addSubview:distanceLabel];
  
  UIImageView *spotImageView;
  
  //insert image
  if(xamoomAnnotationView.spotImage != nil) {
    if (xamoomAnnotationView.spotImage.size.width < xamoomAnnotationView.spotImage.size.height) {
      spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, xamoomCalloutView.frame.size.width, xamoomCalloutView.frame.size.width)];
    } else {
      float imageRatio = xamoomAnnotationView.spotImage.size.width / xamoomAnnotationView.spotImage.size.height;
      spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, xamoomCalloutView.frame.size.width, xamoomCalloutView.frame.size.width / imageRatio)];
    }
    
    [spotImageView setContentMode: UIViewContentModeScaleToFill];
    spotImageView.image = xamoomAnnotationView.spotImage;
    
    //increase pingeborCalloutView height
    CGRect xamoomCalloutViewRect = xamoomCalloutView.frame;
    xamoomCalloutViewRect.size.height += spotImageView.frame.size.height;
    xamoomCalloutView.frame = xamoomCalloutViewRect;
    
    [xamoomCalloutView addSubview:spotImageView];
  }
  
  //insert spotdescription
  if (![xamoomAnnotationView.data.descriptionOfSpot isEqualToString:@""]) {
    UILabel *spotDescriptionLabel;
    if ([xamoomCalloutView.subviews count] >= 3) {
      spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, spotImageView.frame.size.height + spotImageView.frame.origin.y + 5.0f, 280.0f, 25.0f)];
    } else {
      spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height + 5.0f, 280.0f, 25.0f)];
    }
    
    spotDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    spotDescriptionLabel.numberOfLines = 0;
    spotDescriptionLabel.font = [UIFont systemFontOfSize:12];
    spotDescriptionLabel.textColor = [UIColor darkGrayColor];
    spotDescriptionLabel.text = xamoomAnnotationView.data.descriptionOfSpot;
    
    //resize label depending on content
    CGRect spotDescriptionLabelRect = spotDescriptionLabel.frame;
    spotDescriptionLabelRect.size = [spotDescriptionLabel sizeThatFits:spotDescriptionLabelRect.size];
    spotDescriptionLabel.frame = spotDescriptionLabelRect;
    
    //increase pingeborCalloutView height
    CGRect xamoomCalloutViewRect = xamoomCalloutView.frame;
    xamoomCalloutViewRect.size.height += spotDescriptionLabel.frame.size.height + 10.0f;
    xamoomCalloutView.frame = xamoomCalloutViewRect;
    
    [xamoomCalloutView addSubview:spotDescriptionLabel];
  }
  
  //create, design and adjust navigationButton
  UIButton *navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, xamoomCalloutView.frame.size.height, 300.0f, 60.0f)];
  navigationButton.backgroundColor = [Globals sharedObject].pingeborgLinkColor;
  [navigationButton setImage:[[UIImage imageNamed:@"car"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
  navigationButton.tintColor = [UIColor whiteColor];
  [navigationButton setImageEdgeInsets: UIEdgeInsetsMake(-10.0f, navigationButton.titleEdgeInsets.right, 10.0f, navigationButton.titleEdgeInsets.left)];
  
  //increase pingeborCalloutView height
  xamoomCalloutViewRect = xamoomCalloutView.frame;
  xamoomCalloutViewRect.size.height += navigationButton.frame.size.height - 20.0f;
  xamoomCalloutView.frame = xamoomCalloutViewRect;
  
  [navigationButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapNavigationTapped)]];
  
  [xamoomCalloutView addSubview:navigationButton];
  
  return xamoomCalloutView;
}

#pragma mark - MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  if ([annotation isKindOfClass:[XMMAnnotation class]]) {
    static NSString *identifier = @"xamoomAnnotation";
    XMMAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[XMMAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = NO;
      
      //set mapmarker
      if(self.customMapMarker) {
        annotationView.image = self.customMapMarker;
      } else if (self.customSVGMapMarker) {
        annotationView.image = self.customSVGMapMarker.UIImage;
      } else {
        annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
      }
      
      //save data in annotationView
      XMMAnnotation *xamoomAnnotation = (XMMAnnotation*)annotation;
      annotationView.data = xamoomAnnotation.data;
      annotationView.distance = xamoomAnnotation.distance;
      annotationView.coordinate = xamoomAnnotation.coordinate;
      
      //download image
      [XMMImageUtility imageWithUrl:xamoomAnnotation.data.image completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
        if (image != nil) {
          annotationView.spotImage = image;
        } else if (svgImage != nil) {
          NSLog(@"There are no svgImages");
        } else {
          annotationView.spotImage = image;
        }
      }];
      
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
  // create our custom callout view
  SMCalloutView *calloutView = [SMCalloutView platformCalloutView];
  calloutView.delegate = self;
  [calloutView setContentViewInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  self.mapKitWithSMCalloutView.calloutView = calloutView;
  
  if ([annotationView isKindOfClass:[XMMAnnotationView class]]) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:[NSString stringWithFormat:@"Map Pin"] andValue:nil];
    
    calloutView.contentView = [self createMapCalloutFrom:annotationView];
    calloutView.calloutOffset = annotationView.calloutOffset;
    
    [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapKitWithSMCalloutView animated:YES];
  }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  [self.mapKitWithSMCalloutView.calloutView dismissCalloutAnimated:YES];
}

#pragma mark - SMCalloutView delegate methods

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
  // reposition if offscreen
  CLLocationCoordinate2D coordinate = self.mapKitWithSMCalloutView.centerCoordinate;
  
  // where's the center coordinate in terms of our view?
  CGPoint center = [self.mapKitWithSMCalloutView convertCoordinate:coordinate toPointToView:self.mapKitWithSMCalloutView];
  
  // move it by the requested offset
  center.x -= offset.width;
  center.y -= offset.height;
  
  // and translate it back into map coordinates
  coordinate = [self.mapKitWithSMCalloutView convertPoint:center toCoordinateFromView:self.mapKitWithSMCalloutView];
  
  [self.mapKitWithSMCalloutView setCenterCoordinate:coordinate animated:YES];
  
  return kSMCalloutViewRepositionDelayForUIScrollView;
}

#pragma mark User Interaction

- (void)mapNavigationTapped {
  //navigate to the coordinates of the xamoomCalloutView
  XMMCalloutView *xamoomCalloutView = (XMMCalloutView* )self.mapKitWithSMCalloutView.calloutView.contentView;
  
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"Map Callout Navigation Button" andValue:nil];
  
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:xamoomCalloutView.coordinate addressDictionary:nil];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = xamoomCalloutView.nameOfSpot;
  
  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
  [mapItem openInMapsWithLaunchOptions:launchOptions];
}

#pragma mark - LocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  self.lastLocation = [locations lastObject];
  
  self.savedResponseContent = nil;
  
  //make a geofence
  [self disableGeofenceView];
  [self.geoFenceActivityIndicator startAnimating];
  self.geoFenceLabel.text = NSLocalizedString(@"Searching ...", nil);
  [[XMMEnduserApi sharedInstance] contentWithLat:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.latitude] withLon:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.longitude] withLanguage:@""
                                      completion:^(XMMContentByLocation *result) {
                                        [self showDataWithLocation:result];
                                      } error:^(XMMError *error) {
                                      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  if ([self.itemsToDisplay[indexPath.row] isKindOfClass:[XMMContentByLocationItem class]]) {
    //geofence cell like the feedItemCell
    static NSString *simpleTableIdentifier = @"FeedItemCell";
    
    FeedItemCell *cell = (FeedItemCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
      cell = nib[0];
    }
    
    [cell.loadingIndicator startAnimating];
    
    //set defaults to images
    cell.feedItemImage.image = nil;
    [cell.feedItemImage.subviews  makeObjectsPerformSelector: @selector(removeFromSuperview)];
    cell.loadingIndicator.hidden = NO;
    
    //save for out of range
    if (indexPath.row >= [self.itemsToDisplay count]) {
      return cell;
    }
    
    XMMContent *contentItem = (self.itemsToDisplay)[indexPath.row];
    
    //set title
    cell.feedItemTitle.text = contentItem.title;
    
    //set image & grayscale if needed
    if((self.imagesToDisplay)[contentItem.contentId] != nil) {
      UIImage *image = (self.imagesToDisplay)[contentItem.contentId];
      float imageRatio = image.size.width / image.size.height;
      [cell.imageHeightConstraint setConstant:(cell.frame.size.width / imageRatio)];
      
      if ([(self.imagesToDisplay)[contentItem.contentId] isKindOfClass:[SVGKImage class]]) {
        SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:(self.imagesToDisplay)[contentItem.contentId]];
        [svgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / imageRatio))];
        [cell.feedItemImage addSubview:svgImageView];
      } else if (![[[Globals sharedObject] savedArtits] containsString:contentItem.contentId]) {
        cell.feedItemImage.image = [XMMImageUtility convertImageToGrayScale:image];
        cell.feedItemOverlayImage.backgroundColor = [UIColor whiteColor];
        cell.feedItemOverlayImage.image = [UIImage imageNamed:@"discoverable"];
      } else {
        cell.feedItemImage.image = image;
        cell.feedItemOverlayImage.backgroundColor = [UIColor clearColor];
        cell.feedItemOverlayImage.image = nil;
      }
      
      [cell.loadingIndicator stopAnimating];
    }
    
    cell.contentId = contentItem.contentId;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArtistDetailViewFromSender:)];
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
  } else {
    //closest spots locationItem Cell defined in storyboard
    cell = [tableView dequeueReusableCellWithIdentifier:@"LocationItem" forIndexPath:indexPath];
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationItem"];
    }
    
    XMMSpot *item = self.itemsToDisplay[indexPath.row];
    cell.textLabel.text = item.displayName;
    
    //calc distance
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:item.lat longitude:item.lon];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Distance: %d meter", nil), (int)distance];
    
    //make cell transparent
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  
  return cell;
}

#pragma mark - GeoFencing UI/UX

- (IBAction)openGeoFencing:(UIButton *)sender {
  [self toggleGeoFenceView];
}

//add gestures, change icon and stop loading indicator on geofence view
- (void)enableGeofenceView {
  [self.geofenceView addGestureRecognizer:self.geoFenceTapGesture];
  [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewUp];
  
  self.geoFenceIcon.image = [UIImage imageNamed:@"angleDown"];
  self.geoFenceIcon.transform = CGAffineTransformMakeRotation(M_PI);
  [self.geoFenceActivityIndicator stopAnimating];
  [self.tableView reloadData];
}

//close, remove gestures and start loading indicator
- (void)disableGeofenceView {
  if (self.isUp) {
    [self toggleGeoFenceView];
  }
  [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewDown];
  [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewUp];
  [self.geofenceView removeGestureRecognizer:self.geoFenceTapGesture];
  self.geoFenceIcon.image = nil;
  [self.geoFenceActivityIndicator stopAnimating];
}

- (void)toggleGeoFenceView {
  [self.view layoutIfNeeded];
  
  if (self.isUp) {
    //hide tableview
    self.tableViewHeightConstraint.constant = 0.0f;
    [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewDown];
    [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewUp];
  } else {
    //bring up tableview
    if (self.savedResponseContent != nil) {
      UIImage *image = self.imagesToDisplay[self.savedResponseContent.contentId];
      float imageRatio = image.size.width / image.size.height;
      if (!isnan(imageRatio))
        self.tableViewHeightConstraint.constant = (self.view.frame.size.width / imageRatio);
      else
        self.tableViewHeightConstraint.constant = self.view.frame.size.height / 2;
      self.tableView.scrollEnabled = NO;
      self.tableView.bounces = NO;
    } else {
      self.tableViewHeightConstraint.constant = (self.view.frame.size.height/2) + 40;
    }
    
    [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewUp];
    [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewDown];
  }
  
  //animate change
  [UIView animateWithDuration:0.5
                   animations:^{
                     if (self.isUp)
                       self.geoFenceIcon.transform = CGAffineTransformMakeRotation(M_PI);
                     else
                       self.geoFenceIcon.transform = CGAffineTransformMakeRotation(0);
                     [self.view layoutIfNeeded]; // Called on parent view
                     self.isUp = !self.isUp;
                   }];
  
  if (self.isUp)
    [self.tableView reloadData];
}

- (void)openArtistDetailViewFromSender:(UITapGestureRecognizer*)sender {
  //open geofence in artistDetailView
  FeedItemCell *cell = (FeedItemCell*)sender.view;
  ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
  artistDetailViewController.contentId = cell.contentId;
  
  //add to discovered artists
  [[Globals sharedObject] addDiscoveredArtist:cell.contentId];
  
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"Geofence" andValue:nil];
  [[XMMEnduserApi sharedInstance] geofenceAnalyticsMessageWithRequestedLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                          withDeliveredLanguage:self.savedResponseContent.language
                                                                   withSystemId:self.savedResponseContent.systemId
                                                                 withSystemName:self.savedResponseContent.systemName
                                                                  withContentId:self.savedResponseContent.contentId
                                                                withContentName:self.savedResponseContent.contentName
                                                                     withSpotId:self.savedResponseContent.spotId
                                                                   withSpotName:self.savedResponseContent.spotName];
  
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

- (void)refreshContentByLocation {
  [self.tableView reloadData];
}

- (IBAction)closeInstructionView:(id)sender {
  self.instructionView.hidden = YES;
}

@end

#pragma mark - Custom Map View (subclass)

@interface MKMapView (UIGestureRecognizer)

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end

@implementation PingeborgMapView

// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isKindOfClass:[UIControl class]])
    return NO;
  else
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

// Allow touches to be sent to our calloutview.
// See this for some discussion of why we need to override this: https://github.com/nfarina/calloutview/pull/9
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
  if (calloutMaybe) return calloutMaybe;
  
  return [super hitTest:point withEvent:event];
}

@end
