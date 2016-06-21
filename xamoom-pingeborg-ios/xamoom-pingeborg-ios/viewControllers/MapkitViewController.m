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

@interface MapkitViewController ()

@property JGProgressHUD *hud;
@property MapItemDetailView *mapItemDetailView;

@property CLLocationManager *locationManager;
@property CLLocation *lastLocation;

@property UIImage *mapMarker;
@property XMMContent *savedResponseContent;

@property NSArray *spots;

@end

@implementation MapkitViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //analytics
  [[Analytics sharedObject] setScreenName:@"Map View"];
  
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"map_filled"]];
  
  self.mapMarker = [UIImage imageNamed:@"mappoint"];
  
  [self setupMapView];
  [self setupLocationManager];
  [self setupMapItemDetailView];
  
  [self zoomMapToLat:46.623791 andLon:14.308549 andDelta:0.09f];
  
  //check for firstTime geofencing
  if ([[Globals sharedObject] isFirstTimeGeofencing]) {
    self.instructionView.hidden = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  self.parentViewController.navigationItem.title = NSLocalizedString(@"Map", nil);
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //create userTracking button
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
  
  //load spotmap if there are no annotations on the map
  if (self.mapView.annotations.count <= 1) {
    [self.hud showInView:self.view];
    
    [[XMMEnduserApi sharedInstance] spotsWithTags:@[@"showAllTheSpots"] options:XMMSpotOptionsIncludeContent completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
      
      XMMSpot *spot = spots.firstObject;
      [[XMMEnduserApi sharedInstance] styleWithID:spot.system.ID
                                       completion:^(XMMStyle *style, NSError *error) {
                                         [self mapMarkerFromBase64:style.customMarker];
                                         [self showSpotMap:spots];
                                         [self.hud dismissAnimated:YES];
                                       }];
    }];
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Setup

- (void)setupMapView {
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
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

- (void)setupMapItemDetailView {
  self.mapItemDetailView = [[MapItemDetailView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  self.mapItemDetailView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.mapItemDetailView];
  
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapItemDetailView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapItemDetailView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapItemDetailView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapItemDetailView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:0.0f]];
  
}

#pragma mark - XMMEnduser Methods

- (void)showSpotMap:(NSArray *)spots {
  //get the customMarker for the map
  
  // Add annotations
  for (XMMSpot *item in spots) {
    PingebAnnotation *point = [[PingebAnnotation alloc] initWithSpot:item
                                                        userLocation:self.locationManager.location];
    [self.mapView addAnnotation:point];
  }
}

- (void)mapMarkerFromBase64:(NSString*)base64String {
  if ([base64String containsString:@"data:image/svg"]) {
    //create svg need
    base64String = [base64String stringByReplacingOccurrencesOfString:@"data:image/svg+xml;base64," withString:@""];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    JAMSVGImage *svgImage = [JAMSVGImage imageWithSVGData:decodedData];
    self.mapMarker = [svgImage image];
  } else {
    //create UIImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:base64String]];
    self.mapMarker = [XMMImageUtility imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
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
  [self.mapView setRegion:region animated:YES];
}

#pragma mark - MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  if ([annotation isKindOfClass:[PingebAnnotation class]]) {
    static NSString *identifier = @"xamoomAnnotation";
    MKAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = YES;
      
      //set mapmarker
      annotationView.image = self.mapMarker;
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
  
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  
}

#pragma mark User Interaction

- (void)showMapItemDetailView {
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     CGRect frame = self.mapItemDetailView.frame;
                     frame.origin.y = 0;
                     self.mapItemDetailView.frame = frame;
                   } completion:NULL];
}

- (void)hideMapItemDetailView {
  
}

- (void)mapNavigationTapped {
  //navigate to the coordinates of the xamoomCalloutView
  /*
   XMMCalloutView *xamoomCalloutView = self.mapKitWithSMCalloutView.calloutView.contentView;
   
   //analytics
   [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"Map Callout Navigation Button" andValue:nil];
   
   MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:xamoomCalloutView.coordinate addressDictionary:nil];
   
   MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
   mapItem.name = xamoomCalloutView.nameOfSpot;
   
   NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
   [mapItem openInMapsWithLaunchOptions:launchOptions];
   */
}

#pragma mark - LocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  self.lastLocation = [locations firstObject];
  
  self.savedResponseContent = nil;
}

#pragma mark - UI/UX

- (IBAction)closeInstructionView:(id)sender {
  self.instructionView.hidden = YES;
}

@end
