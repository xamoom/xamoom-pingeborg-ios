//
//  MapkitViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 01/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MapkitViewController.h"

// We need a custom subclass of MKMapView in order to allow touches on UIControls in our custom callout view.
@interface CustomMapView : MKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

@interface MapkitViewController ()

@property bool isUp;
@property UIImage *placeholder;
@property UISwipeGestureRecognizer *swipeGeoFenceViewUp;
@property UISwipeGestureRecognizer *swipeGeoFenceViewDown;
@property UITapGestureRecognizer *geoFenceTapGesture;
@property XMMResponseGetByLocationItem *savedResponseContent;

@end

@implementation MapkitViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"map_filled"]];
  
  self.placeholder = [UIImage imageNamed:@"placeholder"];
  self.isUp = NO;
  
  //init map
  self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
  self.mapKitWithSMCalloutView.delegate = self;
  self.mapKitWithSMCalloutView.showsUserLocation = YES;
  [self.viewForMap addSubview:self.mapKitWithSMCalloutView];
  
  //shadow for geoFenceView
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.geofenceView.bounds];
  self.geofenceView.layer.masksToBounds = NO;
  self.geofenceView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.geofenceView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
  self.geofenceView.layer.shadowOpacity = 0.9f;
  self.geofenceView.layer.shadowPath = shadowPath.CGPath;
  
  //setting up tableView
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
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
  
  //map region for zooming
  MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
  
  region.center.latitude = 46.623791;
  region.center.longitude = 14.308549;
  region.span.longitudeDelta = 0.09f;
  region.span.longitudeDelta = 0.09f;
  [self.mapKitWithSMCalloutView setRegion:region animated:YES];
  
  //create geofence GestureRecognizers
  self.swipeGeoFenceViewUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewUp.direction = UISwipeGestureRecognizerDirectionUp;
  self.swipeGeoFenceViewDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewDown.direction = UISwipeGestureRecognizerDirectionDown;
  self.geoFenceTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  
  //pingeborg system notifications
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshContentByLocation)
                                               name:@"updateAllArtistLists"
                                             object:nil];
  
  //check for firstTime geofencing
  if ([Globals isFirstTimeGeofencing]) {
    self.instructionView.hidden = NO;
  }
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.locationManager startUpdatingLocation];
  
  //create userTracking button
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapKitWithSMCalloutView];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
  
  //load spotmap if there are no annotations on the map
  if (self.mapKitWithSMCalloutView.annotations.count <= 0 ) {
    [self.geoFenceActivityIndicator startAnimating];
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] spotMapWithSystemId:0 withMapTags:@[@"showAllTheSpots"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = nil;
  [self.locationManager stopUpdatingLocation];
}

#pragma mark - XMMEnduser Delegate

- (void)didLoadSpotMap:(XMMResponseGetSpotMap *)result {
  //get the customMarker for the map
  if (result.style.customMarker != nil) {
    NSString *base64String = result.style.customMarker;
    
    //decode two times!
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [XMMImageUtility imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
    
    //svg support
    if (!self.customMapMarker) {
      //save svg mapmarker
      NSArray *paths = NSSearchPathForDirectoriesInDomains
      (NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = paths[0];
      NSString *fileName = [NSString stringWithFormat:@"%@/mapmarker.svg", documentsDirectory];
      [imageData writeToFile:fileName atomically:YES];
      
      //read svg mapmarker
      NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
      self.customSVGMapMarker = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:
                                                            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
    }
  }
  
  // Add annotations
  for (XMMResponseGetSpotMapItem *item in result.items) {
    PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake(item.lat, item.lon)];
    point.data = item;
    
    //calculate distance to annotation
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    point.distance = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
    
    [self.mapKitWithSMCalloutView addAnnotation:point];
  }
}

-(void)didLoadDataWithLocation:(XMMResponseGetByLocation *)result {
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.imagesToDisplay = [[NSMutableDictionary alloc] init];
  
  //load items in near you, when there is no geofence
  if([result.items count] == 0) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [XMMEnduserApi sharedInstance].delegate = self;
    [[XMMEnduserApi sharedInstance] closestSpotsWithLat:self.lastLocation.coordinate.latitude withLon:self.lastLocation.coordinate.longitude withRadius:2000 withLimit:10 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    return;
  }
  
  for (XMMResponseGetByLocationItem *item in result.items) {
    //check if item is in pingeborg-system => GEOFENCE
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
  self.geoFenceLabel.text = @"pingeb.org entdeckt!";
  [self enableGeofenceView];
}

- (void)didLoadClosestSpots:(XMMResponseClosestSpot *)result {
  for (XMMResponseGetSpotMapItem *item in result.items) {
    [self.itemsToDisplay addObject:item];
  }
  
  if ([self.itemsToDisplay count] > 0) {
    self.geoFenceLabel.text = [NSString stringWithFormat:@"%lu in der Nähe", (unsigned long)[self.itemsToDisplay count]];
    [self enableGeofenceView];
  } else {
    self.geoFenceLabel.text = @"Nichts in deiner Nähe";
    [self disableGeofenceView];
  }
}

#pragma mark - MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  if ([annotation isKindOfClass:[PingebAnnotation class]]) {
    static NSString *identifier = @"PingebAnnotation";
    PingeborgAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = NO;
      
      //set mapmarker
      if(self.customMapMarker) {
        annotationView.image = self.customMapMarker;
      } else if (self.customSVGMapMarker) {
        [annotationView displaySVG:self.customSVGMapMarker];
      } else {
        annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
      }
      
      //save data in annotationView
      PingebAnnotation *pingebAnnotation = (PingebAnnotation*)annotation;
      annotationView.data = pingebAnnotation.data;
      annotationView.distance = pingebAnnotation.distance;
      annotationView.coordinate = pingebAnnotation.coordinate;
      
      //download image
      [XMMImageUtility imageWithUrl:pingebAnnotation.data.image completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
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
  
  if ([annotationView isKindOfClass:[PingeborgAnnotationView class]]) {
    PingeborgAnnotationView* pingeborgAnnotationView = (PingeborgAnnotationView *)annotationView;
    PingeborgCalloutView* pingeborgCalloutView = [[PingeborgCalloutView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 35.0f)];
    pingeborgCalloutView.nameOfSpot = pingeborgAnnotationView.data.displayName;
    
    //create titleLabel
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 280.0f, 25.0f)];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = pingeborgAnnotationView.data.displayName;
    
    //size label to fit content
    CGRect titleLabelRect = titleLabel.frame;
    titleLabelRect.size = [titleLabel sizeThatFits:titleLabelRect.size];
    titleLabel.frame = titleLabelRect;
    
    [pingeborgCalloutView addSubview:titleLabel];
    
    //increase pingeborCalloutView height
    CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
    pingeborgCalloutViewRect.size.height += titleLabel.frame.size.height;
    pingeborgCalloutView.frame = pingeborgCalloutViewRect;
    
    //create distance label
    UILabel* distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, titleLabel.frame.size.height + 10.0f, 280.0f, 25.0f)];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = pingeborgAnnotationView.distance;
    
    //set coordinates (for navigating)
    pingeborgCalloutView.coordinate = pingeborgAnnotationView.coordinate;
    
    
    [pingeborgCalloutView addSubview:distanceLabel];
    
    UIImageView *spotImageView;
    
    //insert image
    if(pingeborgAnnotationView.spotImage != nil) {
      if (pingeborgAnnotationView.spotImage.size.width < pingeborgAnnotationView.spotImage.size.height) {
        spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, pingeborgCalloutView.frame.size.width, pingeborgCalloutView.frame.size.width)];
      } else {
        float imageRatio = pingeborgAnnotationView.spotImage.size.width / pingeborgAnnotationView.spotImage.size.height;
        spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, pingeborgCalloutView.frame.size.width, pingeborgCalloutView.frame.size.width / imageRatio)];
      }
      
      [spotImageView setContentMode: UIViewContentModeScaleToFill];
      spotImageView.image = pingeborgAnnotationView.spotImage;
      
      //increase pingeborCalloutView height
      CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
      pingeborgCalloutViewRect.size.height += spotImageView.frame.size.height;
      pingeborgCalloutView.frame = pingeborgCalloutViewRect;
      
      [pingeborgCalloutView addSubview:spotImageView];
    }
    
    //insert spotdescription
    if (![pingeborgAnnotationView.data.descriptionOfSpot isEqualToString:@""]) {
      UILabel *spotDescriptionLabel;
      if ([pingeborgCalloutView.subviews count] >= 3) {
        spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, spotImageView.frame.size.height + spotImageView.frame.origin.y + 5.0f, 280.0f, 25.0f)];
      } else {
        spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height + 5.0f, 280.0f, 25.0f)];
      }
      
      spotDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
      spotDescriptionLabel.numberOfLines = 0;
      spotDescriptionLabel.font = [UIFont systemFontOfSize:12];
      spotDescriptionLabel.textColor = [UIColor darkGrayColor];
      spotDescriptionLabel.text = pingeborgAnnotationView.data.descriptionOfSpot;
      
      //resize label depending on content
      CGRect spotDescriptionLabelRect = spotDescriptionLabel.frame;
      spotDescriptionLabelRect.size = [spotDescriptionLabel sizeThatFits:spotDescriptionLabelRect.size];
      spotDescriptionLabel.frame = spotDescriptionLabelRect;
      
      //increase pingeborCalloutView height
      CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
      pingeborgCalloutViewRect.size.height += spotDescriptionLabel.frame.size.height + 10.0f;
      pingeborgCalloutView.frame = pingeborgCalloutViewRect;
      
      [pingeborgCalloutView addSubview:spotDescriptionLabel];
    }
    
    //create, design and adjust navigationButton
    UIButton *navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, pingeborgCalloutView.frame.size.height, 300.0f, 60.0f)];
    navigationButton.backgroundColor = [Globals sharedObject].pingeborgLinkColor;
    [navigationButton setImage:[[UIImage imageNamed:@"car"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    navigationButton.tintColor = [UIColor whiteColor];
    [navigationButton setImageEdgeInsets: UIEdgeInsetsMake(-10.0f, navigationButton.titleEdgeInsets.right, 10.0f, navigationButton.titleEdgeInsets.left)];
    
    //increase pingeborCalloutView height
    pingeborgCalloutViewRect = pingeborgCalloutView.frame;
    pingeborgCalloutViewRect.size.height += navigationButton.frame.size.height - 20.0f;
    pingeborgCalloutView.frame = pingeborgCalloutViewRect;
    
    [navigationButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapNavigationTapped)]];

    [pingeborgCalloutView addSubview:navigationButton];
    
    //set custom contentView
    calloutView.contentView = pingeborgCalloutView;
    
    // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
    calloutView.calloutOffset = annotationView.calloutOffset;
    
    // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
      calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    
    [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapKitWithSMCalloutView animated:YES];
  }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  [self.mapKitWithSMCalloutView.calloutView dismissCalloutAnimated:YES];
}

#pragma mark - SMCalloutView delegate methods

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
  
  // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
  // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
  // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
  
  CLLocationCoordinate2D coordinate = self.mapKitWithSMCalloutView.centerCoordinate;
  
  // where's the center coordinate in terms of our view?
  CGPoint center = [self.mapKitWithSMCalloutView convertCoordinate:coordinate toPointToView:self.mapKitWithSMCalloutView];
  
  // move it by the requested offset
  center.x -= offset.width;
  center.y -= offset.height;
  
  // and translate it back into map coordinates
  coordinate = [self.mapKitWithSMCalloutView convertPoint:center toCoordinateFromView:self.mapKitWithSMCalloutView];
  
  // move the map!
  [self.mapKitWithSMCalloutView setCenterCoordinate:coordinate animated:YES];
  
  // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
  return kSMCalloutViewRepositionDelayForUIScrollView;
}

#pragma mark User Interaction

- (void)mapNavigationTapped {
  //navigate to the coordinates of the pingeborgCalloutView
  PingeborgCalloutView *pingeborgCalloutView = (PingeborgCalloutView* )self.mapKitWithSMCalloutView.calloutView.contentView;
  
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pingeborgCalloutView.coordinate addressDictionary:nil];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = pingeborgCalloutView.nameOfSpot;
  
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
  self.geoFenceLabel.text = @"Auf der Suche ...";
  [XMMEnduserApi sharedInstance].delegate = self;
  [[XMMEnduserApi sharedInstance] contentWithLat:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.latitude] withLon:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.longitude] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
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
  
  if ([self.itemsToDisplay[indexPath.row] isKindOfClass:[XMMResponseGetByLocationItem class]]) {
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
    XMMResponseContent *contentItem = (self.itemsToDisplay)[indexPath.row];
    
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
      } else if (![[Globals savedArtits] containsString:contentItem.contentId]) {
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
    
    XMMResponseGetSpotMapItem *item = self.itemsToDisplay[indexPath.row];
    cell.textLabel.text = item.displayName;
    
    //calc distance
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:item.lat longitude:item.lon];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
    
    //make cell transparent
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - NavbarDropdown Delegation

- (void)pingeborgSystemChanged {
  NSLog(@"pingeborgSystemChanged");
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
  [Globals addDiscoveredArtist:cell.contentId];
  
  //analytics
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

@implementation CustomMapView

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
