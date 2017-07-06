//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock9TableViewCell.h"

#define MINIMUM_ZOOM_ARC 0.014
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@interface XMMContentBlock9TableViewCell()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *currentContentID;
@property (nonatomic) bool showContent;
@property (nonatomic) bool didLoadStyle;
@property (nonatomic, strong) NSMutableArray *spots;

@end

@implementation XMMContentBlock9TableViewCell

static UIColor *kContentLinkColor;
static NSString *kContentLanguage;
static int kPageSize = 100;

- (void)awakeFromNib {
  // Initialization code
  self.clipsToBounds = YES;
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url != nil) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
  
  [self setupLocationManager];
  [self setupMapOverlayView];
  self.mapHeightConstraint.constant = [UIScreen mainScreen].bounds.size.width - 50;
  
  self.didLoadStyle = NO;
  [super awakeFromNib];
}

- (void)setupMapView {
  self.mapView.delegate = self;
}

- (void)setupLocationManager {
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

- (void)setupMapOverlayView {
  self.mapAdditionView = [[self.bundle loadNibNamed:@"XMMMapOverlayView" owner:self options:nil] firstObject];
  
  self.mapAdditionView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:self.mapAdditionView];
  
  [self.contentView addConstraint:
   [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                attribute:NSLayoutAttributeLeading
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.contentView
                                attribute:NSLayoutAttributeLeading
                               multiplier:1
                                 constant:0]];
  
  [self.contentView addConstraint:
   [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                   toItem:self.mapView
                                attribute:NSLayoutAttributeTrailing
                               multiplier:1
                                 constant:0]];
  
  self.mapAdditionViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.mapView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1
                                                                       constant:self.mapView.bounds.size.height/2 + 10];
  [self.contentView addConstraint:self.mapAdditionViewBottomConstraint];
  
  self.mapAdditionViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.mapAdditionView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:self.mapView.bounds.size.height/2];
  
  [self.mapAdditionView addConstraint:self.mapAdditionViewHeightConstraint];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  if (offline) {
    return;
  }
  
  self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  
  self.titleLabel.text = block.title;
  
  if (style.customMarker != nil) {
    [self mapMarkerFromBase64:style.customMarker];
    self.didLoadStyle = YES;
  }
  
  self.showContent = block.showContent;
  
  [self getSpotMap:api spotMapTags:block.spotMapTags];
  [self updateConstraints];
}

- (void)getSpotMap:(XMMEnduserApi *)api spotMapTags:(NSArray *)spotMapTags {
  NSArray *spots = [[XMMContentBlocksCache sharedInstance] cachedSpotMap:[spotMapTags componentsJoinedByString:@","]];
  if (spots) {
    [self.loadingIndicator stopAnimating];
    [self setupMapView];
    [self showSpotMap:spots];
    
    XMMSpot *spot = spots.firstObject;
    if (self.didLoadStyle == NO) {
      [self getStyleWithId:spot.system.ID api:api spotMapTags:spotMapTags];
    }
    
    return;
  }
  
  self.spots = [[NSMutableArray alloc] init];
  [self downloadAllSpotsWithSpots:spotMapTags cursor:nil api:api completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    [self.loadingIndicator stopAnimating];
    [self setupMapView];
    [self showSpotMap:spots];
  }];
}

- (void)downloadAllSpotsWithSpots:(NSArray *)tags cursor:(NSString *)cursor api:(XMMEnduserApi *)api completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  NSUInteger options = XMMSpotOptionsWithLocation;
  if (self.showContent) {
    options = options|XMMSpotOptionsIncludeContent;
  }
  
  [api spotsWithTags:tags pageSize:kPageSize cursor:cursor options:options sort:0 completion:^(NSArray *spots, bool hasMore, NSString *cursor, NSError *error) {
    if (error != nil) {
      completion(nil, false, nil, error);
    }
    
    [self.spots arrayByAddingObjectsFromArray:spots];
    
    if (self.didLoadStyle == NO && spots.count > 0) {
      XMMSpot *spot = spots.firstObject;
      [self getStyleWithId:spot.system.ID api:api spotMapTags:tags];
    }
    
    if (hasMore) {
      [self downloadAllSpotsWithSpots:tags cursor:cursor api:api completion:completion];
    } else {
      completion(spots, false, nil, nil);
    }
  }];
}

- (void)getStyleWithId:(NSString *)systemId api:(XMMEnduserApi *)api spotMapTags:(NSArray *)spotMapTags {
  [api styleWithID:systemId completion:^(XMMStyle *style, NSError *error) {
    self.didLoadStyle = YES;
    [self mapMarkerFromBase64:style.customMarker];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self getSpotMap:api spotMapTags:spotMapTags]; // reloads data to use custom marker
  }];
}

- (void)showSpotMap:(NSArray *)spots {
  // Add annotations
  if (self.mapView.annotations != nil) {
    [self.mapView removeAnnotations:self.mapView.annotations];
  }
  
  for (XMMSpot *spot in spots) {
    NSString *annotationTitle = nil;
    if (spot.name != nil && ![spot.name isEqualToString:@""]) {
      annotationTitle = spot.name;
    } else {
      annotationTitle = @"Spot";
    }
    
    XMMAnnotation *annotation = [[XMMAnnotation alloc] initWithName:annotationTitle withLocation:CLLocationCoordinate2DMake(spot.latitude, spot.longitude)];
    annotation.spot = spot;
    
    //calculate
    CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:annotationLocation];
    if (distance < 1000) {
      annotation.distance = [NSString stringWithFormat:@"%@: %d m", NSLocalizedStringFromTableInBundle(@"Distance", @"Localizable", self.bundle, nil), (int)distance];
    } else {
      annotation.distance = [NSString stringWithFormat:@"%@: %0.1f km", NSLocalizedStringFromTableInBundle(@"Distance", @"Localizable", self.bundle, nil), distance/1000];
    }
    
    [self.mapView addAnnotation:annotation];
  }
  
  [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
}

- (void)mapMarkerFromBase64:(NSString*)base64String {
  if ([base64String containsString:@"data:image/svg"]) {
    base64String = [base64String stringByReplacingOccurrencesOfString:@"data:image/svg+xml;base64," withString:@""];
    NSData *decodedData2 = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    self.customMapMarker= [JAMSVGImage imageWithSVGData:decodedData2].image;
  } else {
    //create UIImage
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:base64String]];
    self.customMapMarker = [UIImage imageWithData:imageData];
  }
  
  self.customMapMarker = [UIImage imageWithImage:self.customMapMarker scaledToMaxWidth:30.0f maxHeight:30.0f];
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  
  if ([annotation isKindOfClass:[XMMAnnotation class]]) {
    static NSString *identifier = @"xamoomAnnotation";
    MKAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = YES;
      annotationView.calloutOffset = CGPointMake(0, -1);
      
      //set mapmarker
      if(self.customMapMarker) {
        annotationView.image = self.customMapMarker;
      } else {
        UIImage *image = [UIImage imageNamed:@"mappoint"
                                          inBundle:self.bundle compatibleWithTraitCollection:nil];
        annotationView.image = image;
      }
    } else {
      annotationView.annotation = annotation;
    }
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
  if ([annotationView isKindOfClass:[MKAnnotationView class]]) {
    XMMAnnotation *annotation =  annotationView.annotation;
    [self zoomToAnnotationWithAdditionView:annotation];
    self.mapAdditionViewBottomConstraint.constant = self.mapView.bounds.size.height/2 + 10;
    self.mapAdditionViewHeightConstraint.constant = self.mapView.bounds.size.height/2;
    [self openMapAdditionView:annotation];
  }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)annotationView {
  if ([annotationView isKindOfClass:[MKAnnotationView class]]) {
    [self closeMapAdditionView];
  }
}

#pragma mark - Custom Methods

- (void)zoomToAnnotationWithAdditionView:(XMMAnnotation *)annotation {
  MKCoordinateRegion region;
  
  region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
  region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
  
  CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude-0.003 longitude:annotation.coordinate.longitude];
  region.center=location.coordinate;
  
  [self.mapView setRegion:region animated:TRUE];
}

- (void)openMapAdditionView:(XMMAnnotation *)annotation {
  [self.mapAdditionView displayAnnotation:annotation showContent:self.showContent];
  
  [self.contentView layoutIfNeeded];
  self.mapAdditionViewBottomConstraint.constant = 0;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

- (void)closeMapAdditionView {
  [self.contentView layoutIfNeeded];
  self.mapAdditionViewBottomConstraint.constant = self.mapAdditionViewHeightConstraint.constant + 10;
  [UIView animateWithDuration:0.3 animations:^{
    [self.contentView layoutIfNeeded];
  }];
}

//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated {
  NSArray *annotations = mapView.annotations;
  int count = (int)[self.mapView.annotations count];
  if (count == 0) {
    return;
  }
  
  MKMapPoint points[count];
  for (int i=0; i<count; i++) {
    CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)annotations[i] coordinate];
    points[i] = MKMapPointForCoordinate(coordinate);
  }

  MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
  MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
  
  region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
  region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
  
  //but padding can't be bigger than the world
  if (region.span.latitudeDelta > MAX_DEGREES_ARC) {
    region.span.latitudeDelta  = MAX_DEGREES_ARC;
  }
  if (region.span.longitudeDelta > MAX_DEGREES_ARC) {
    region.span.longitudeDelta = MAX_DEGREES_ARC;
  }
  
  //and don't zoom in stupid-close on small samples
  if (region.span.latitudeDelta  < MINIMUM_ZOOM_ARC) {
    region.span.latitudeDelta  = MINIMUM_ZOOM_ARC;
  }
  if (region.span.longitudeDelta < MINIMUM_ZOOM_ARC) {
    region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
  }
  //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
  if (count == 1) {
    region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
    region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
  }
  
  [mapView setRegion:region animated:animated];
}

@end
