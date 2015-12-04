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

  [self setupMapView];
  [self setupLocationManager];
  [self.locationManager startUpdatingLocation];
  
  [self zoomMapToLat:46.623791 andLon:14.308549 andDelta:0.09f];
  
  //check for firstTime geofencing
  if ([[Globals sharedObject] isFirstTimeGeofencing]) {
    self.instructionView.hidden = NO;
  }
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //create userTracking button
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapKitWithSMCalloutView];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
  
  //load spotmap if there are no annotations on the map
  if (self.mapKitWithSMCalloutView.annotations.count <= 1) {
    [self.hud showInView:self.view];
    [[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"showAllTheSpots"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage includeContent:YES
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

- (void)setupMapView {
  //init map
  self.mapKitWithSMCalloutView = [[PingeborgMapView alloc] initWithFrame:self.view.bounds];
  self.mapKitWithSMCalloutView.delegate = self;
  self.mapKitWithSMCalloutView.showsUserLocation = YES;
  [self.viewForMap addSubview:self.mapKitWithSMCalloutView];
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
}

#pragma mark - UI/UX

- (void)openArtistDetailViewFromSender:(UITapGestureRecognizer*)sender {
  //open geofence in artistDetailView
  FeedItemCell *cell = (FeedItemCell*)sender.view;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ArtistDetailViewController *artistDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
  
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
