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

@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, strong) MapItemDetailView *mapItemDetailView;
@property (nonatomic, strong) NSLayoutConstraint *mapItemDetailViewBottomConstraint;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;

@property (nonatomic, strong) UIImage *mapMarker;
@property (nonatomic, strong) XMMContent *savedResponseContent;

@property (nonatomic, strong) NSMutableArray *spots;

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
  
  self.spots = [[NSMutableArray alloc] init];
  
  [self setupMapView];
  [self setupLocationManager];
  [self setupMapItemDetailView];
  
  [self zoomMapToLat:46.623791 andLon:14.308549 andDelta:0.09f];
}

- (void)viewWillAppear:(BOOL)animated {
  self.parentViewController.navigationItem.title = NSLocalizedString(@"Map", nil);
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //load spotmap if there are no annotations on the map
  if (self.mapView.annotations.count <= 1) {
    [self downloadSpots:nil];
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
  
  UITapGestureRecognizer *mapTapRecognizer = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(hideMapItemDetailView)];
  [self.mapView addGestureRecognizer:mapTapRecognizer];
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
  
  [self.locationManager startUpdatingLocation];
}

- (void)setupMapItemDetailView {
  self.mapItemDetailView = [[MapItemDetailView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  self.mapItemDetailView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:self.mapItemDetailView];
  
  UISwipeGestureRecognizer *mapItemDetailSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMapItemDetailView)];
  mapItemDetailSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
  [self.mapItemDetailView addGestureRecognizer:mapItemDetailSwipeRecognizer];
  
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
  
  self.mapItemDetailViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.mapItemDetailView
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:0.0f];
  
  [self.view addConstraint:self.mapItemDetailViewBottomConstraint];
}

- (void)addCenterUserButton {
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"location"]
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(centerOnUser)];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
}

#pragma mark - XMMEnduser Methods

- (void)downloadSpots:(NSString *)cursor {
  [self.hud showInView:self.view];
  
  
  [[XMMEnduserApi sharedInstance] spotsWithTags:@[@"showAllTheSpots"] pageSize:100 cursor:cursor options:XMMSpotOptionsIncludeContent sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (spots.count == 0) {
      [self.hud dismissAnimated:YES];
      return;
    }
    
    XMMSpot *spot = spots.firstObject;
    
    if (hasMore) {
      [self.spots addObjectsFromArray:spots];
      [self downloadSpots:cursor];
    } else {
      [self.spots addObjectsFromArray:spots];
      [[XMMEnduserApi sharedInstance] styleWithID:spot.system.ID
                                       completion:^(XMMStyle *style, NSError *error) {
                                         [self mapMarkerFromBase64:style.customMarker];
                                         [self showSpotMap:self.spots];
                                         [self.hud dismissAnimated:YES];
                                       }];
    }
  }];
}


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
  if (base64String == nil) {
    return;
  }
  
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

- (void)centerOnUser {
  if (self.lastLocation != nil) {
  [self zoomMapToLat:self.lastLocation.coordinate.latitude
              andLon:self.lastLocation.coordinate.longitude
            andDelta:0.003f];
  }
}

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
  if ([annotationView.annotation isKindOfClass:[PingebAnnotation class]]) {
    PingebAnnotation *pingebAnnotation = annotationView.annotation;
    [self.mapItemDetailView displaySpotInfo:pingebAnnotation.spot];
    [self.view layoutIfNeeded];
    
    double diff = 0;
    if (self.mapItemDetailViewBottomConstraint.constant < 0) {
      diff = -self.mapItemDetailViewBottomConstraint.constant - self.mapItemDetailView.frame.size.height;
      self.mapItemDetailView.bottomConstraint.constant += diff;
    }
    
    PingebAnnotation *annotation = annotationView.annotation;
    [self moveToAnnotation:annotation];
    [self showMapItemDetailView: diff];
  }
}

- (void)moveToAnnotation:(PingebAnnotation *)annotation {
  MKCoordinateRegion oldRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 800, 800)];
  CLLocationCoordinate2D centerPointOfOldRegion = oldRegion.center;
  
  //Create a new center point (I added a quarter of oldRegion's latitudinal span)
  CLLocationCoordinate2D centerPointOfNewRegion = CLLocationCoordinate2DMake(centerPointOfOldRegion.latitude - oldRegion.span.latitudeDelta/4.0, centerPointOfOldRegion.longitude);
  
  //Create a new region with the new center point (same span as oldRegion)
  MKCoordinateRegion newRegion = MKCoordinateRegionMake(centerPointOfNewRegion, oldRegion.span);
  
  //Set the mapView's region
  [self.mapView setRegion:newRegion animated:YES];
}


#pragma mark User Interaction

- (void)showMapItemDetailView:(double)diff {
  [self.view layoutIfNeeded];
  
  self.mapItemDetailViewBottomConstraint.constant = -self.mapItemDetailView.frame.size.height + diff;
  self.mapItemDetailView.bottomConstraint.constant = 8;
  
  [UIView animateWithDuration:0.7f
                        delay:0.0f
       usingSpringWithDamping:5.0f
        initialSpringVelocity:15.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.view layoutIfNeeded];
                     
                   }
                   completion:nil];
}

- (void)hideMapItemDetailView {
  for (id<MKAnnotation> anno in self.mapView.selectedAnnotations) {
    [self.mapView deselectAnnotation:anno animated:YES];
  }
  
  [self.view layoutIfNeeded];
  
  self.mapItemDetailViewBottomConstraint.constant = 0;
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.view layoutIfNeeded];
                   } completion:NULL];
}

#pragma mark - LocationManager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  self.lastLocation = [locations firstObject];
  
  if (self.lastLocation != nil) {
    [self addCenterUserButton];

  }
  
  self.savedResponseContent = nil;
}

@end
