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

@implementation MapkitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //create annotation
    self.annotationForSMCalloutView = [MKPointAnnotation new];
    self.annotationForSMCalloutView.coordinate = (CLLocationCoordinate2D){28.388154, -80.604200};
    self.annotationForSMCalloutView.title = @"Cape Canaveral";
    self.annotationForSMCalloutView.subtitle = @"Launchpad";
    
    //init map
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
    self.mapKitWithSMCalloutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapKitWithSMCalloutView.delegate = self;
    [self.view addSubview:self.mapKitWithSMCalloutView];
    
    // create our custom callout view
    self.calloutView = [SMCalloutView platformCalloutView];
    self.calloutView.delegate = self;
    
    // tell our custom map view about the callout so it can send it touches
    self.mapKitWithSMCalloutView.calloutView = self.calloutView;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getSpotMapWithSystemId:@"6588702901927936" withMapTag:@"stw" withLanguage:@"de"];
}

-(void)viewDidAppear:(BOOL)animated {
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //map region
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 46.6247222;
    region.center.longitude = 14.3052778;
    region.span.longitudeDelta = 0.09f;
    region.span.longitudeDelta = 0.09f;
    [self.mapKitWithSMCalloutView setRegion:region animated:YES];
    
    //create userTracking button
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapKitWithSMCalloutView];
    self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
}

#pragma mark - XMMEnduser Delegate
- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        point.data = item;
        
        CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
        point.distance = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
        
        NSLog(@"Hellyeah: %@", item.image);
        NSLog(@"Hellyeah: %@", item.descriptionOfSpot);
        
        if (item.image == nil && [item.descriptionOfSpot isEqualToString:@""]) {
            MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
            pointAnnotation.coordinate = point.coordinate;
            pointAnnotation.title = item.displayName;
            pointAnnotation.subtitle = point.distance;
            [self.mapKitWithSMCalloutView addAnnotation:pointAnnotation];
        }
        else {
            [self.mapKitWithSMCalloutView addAnnotation:point];
        }
    }
}

//
// MKMapView delegate methods
//

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //do not touch userLocation
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"PingebAnnotation";
    if ([annotation isKindOfClass:[PingebAnnotation class]]) {
        
        PingeborgAnnotationView *annotationView = (PingeborgAnnotationView *) [self.mapKitWithSMCalloutView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
            PingebAnnotation *pingebAnnotation = (PingebAnnotation*)annotation;
            annotationView.data = pingebAnnotation.data;
            annotationView.distance = pingebAnnotation.distance;
            
            // create a disclosure button for map kit
            /*
            UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
            annotationView.rightCalloutAccessoryView = disclosure;
            */
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
    
    if ([annotationView isKindOfClass:[PingeborgAnnotationView class]]) {
        PingeborgCalloutView* pingeborgCalloutView = [[PingeborgCalloutView alloc] init];
        PingebAnnotation* pingeborgAnnotation = (PingebAnnotation *)annotationView;
        pingeborgCalloutView.title.text = pingeborgAnnotation.data.displayName;
        pingeborgCalloutView.descriptionOfContent.text = pingeborgAnnotation.data.descriptionOfSpot;
        pingeborgCalloutView.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                                       [NSURL URLWithString:pingeborgAnnotation.data.image]]];
        pingeborgCalloutView.distance.text = pingeborgAnnotation.distance;
        self.calloutView.contentView = pingeborgCalloutView;
        
        // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
        self.calloutView.calloutOffset = annotationView.calloutOffset;
        
        // create a disclosure button for comparison
        UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosure addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disclosureTapped)]];
        self.calloutView.rightAccessoryView = disclosure;
        
        // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            self.calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        
        // This does all the magic.
        [self.calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.view animated:YES];
    }
    else {
        NSLog(@"OK");
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [self.calloutView dismissCalloutAnimated:YES];
}

//
// SMCalloutView delegate methods
//

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
    
    // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
    // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
    // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
    
    CLLocationCoordinate2D coordinate = self.mapKitWithSMCalloutView.centerCoordinate;
    
    // where's the center coordinate in terms of our view?
    CGPoint center = [self.mapKitWithSMCalloutView convertCoordinate:coordinate toPointToView:self.view];
    
    // move it by the requested offset
    center.x -= offset.width;
    center.y -= offset.height;
    
    // and translate it back into map coordinates
    coordinate = [self.mapKitWithSMCalloutView convertPoint:center toCoordinateFromView:self.view];
    
    // move the map!
    [self.mapKitWithSMCalloutView setCenterCoordinate:coordinate animated:YES];
    
    // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
    return kSMCalloutViewRepositionDelayForUIScrollView;
}

- (void)disclosureTapped {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tap!" message:@"You tapped the disclosure button."
                                                   delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

@end

//
// Custom Map View
//
// We need to subclass MKMapView in order to present an SMCalloutView that contains interactive
// elements.
//

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
