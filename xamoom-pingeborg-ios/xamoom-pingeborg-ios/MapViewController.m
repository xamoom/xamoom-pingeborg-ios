//
//  MapViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 11/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.mapView.delegate = self;
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getSpotMapWithSystemId:@"6588702901927936" withMapTag:@"stw" withLanguage:@"de"];
    
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.parentViewController.navigationItem.title = @"Map";
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //map region
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 46.6247222;
    region.center.longitude = 14.3052778;
    region.span.longitudeDelta = 0.09f;
    region.span.longitudeDelta = 0.09f;
    [self.mapView setRegion:region animated:YES];
    
    //create userTracking button
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
}

-(void)viewWillDisappear:(BOOL)animated {
    //remove userTracking button
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - XMMEnduser Delegate
- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {

    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        //point.title = item.displayName;
        //point.image = item.image;
        
        CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
        //point.subtitle = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];

        [self.mapView addAnnotation:point];
    }
}

#pragma mark - Map
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //do not touch userLocation
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"PingebAnnotation";
    if ([annotation isKindOfClass:[PingebAnnotation class]]) {
        
        PingeborgAnnotationView *annotationView = (PingeborgAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //opens maps with direction to the mappin
    PingebAnnotation *pinAnn = view.annotation;
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [pinAnn.mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view isKindOfClass:PingeborgAnnotationView.class]) {
        
        // apply the MKAnnotationView's basic properties
        self.calloutView.title = @"TEST";
        self.calloutView.subtitle = @"More Test";
        //self.calloutView.contentView = [[PingeborgCalloutView alloc] init];
        
        
        // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
        //self.calloutView.calloutOffset = annotationView.calloutOffset;
        
        // create a disclosure button for comparison
        UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutViewClicked)]];
        self.calloutView.rightAccessoryView = disclosure;
        
        // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            self.calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        
        // This does all the magic.
        [self.calloutView presentCalloutFromRect:view.bounds inView:view constrainedToView:self.view animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.calloutView dismissCalloutAnimated:YES];
}

// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]])
        return NO;
    else
        return [self gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

// Allow touches to be sent to our calloutview.
// See this for some discussion of why we need to override this: https://github.com/nfarina/calloutview/pull/9
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"HitTest");
    UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
    if (calloutMaybe) return calloutMaybe;
    
    return [self hitTest:point withEvent:event];
}

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
    
    // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
    // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
    // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
    
    CLLocationCoordinate2D coordinate = self.mapView.centerCoordinate;
    
    // where's the center coordinate in terms of our view?
    CGPoint center = [self.mapView convertCoordinate:coordinate toPointToView:self.view];
    
    // move it by the requested offset
    center.x -= offset.width;
    center.y -= offset.height;
    
    // and translate it back into map coordinates
    coordinate = [self.mapView convertPoint:center toCoordinateFromView:self.view];
    
    // move the map!
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)calloutViewClicked:(SMCalloutView *)calloutView {
    NSLog(@"Hellyeah");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
