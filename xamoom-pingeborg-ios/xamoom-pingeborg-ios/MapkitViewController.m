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
    
    //init map
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
    self.mapKitWithSMCalloutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapKitWithSMCalloutView.delegate = self;
    self.mapKitWithSMCalloutView.showsUserLocation = YES;
    [self.view addSubview:self.mapKitWithSMCalloutView];
        
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getSpotMapWithSystemId:[Globals sharedObject].globalSystemId withMapTags:@"showAllTheSpots" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pingeborgSystemChanged)
                                                 name:@"PingeborgSystemChanged"
                                               object:nil];
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

#pragma mark imageutility
- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - XMMEnduser Delegate
- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    NSString *base64String = result.style.customMarker;
    
    //decode two times!
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    decodedData = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [self imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
    
    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        point.data = item;
        
        CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
        point.distance = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];
        
        [self.mapKitWithSMCalloutView addAnnotation:point];
    }
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //do not touch userLocation
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[PingebAnnotation class]]) {
        static NSString *identifier = @"PingebAnnotation";
        PingeborgAnnotationView *annotationView = (PingeborgAnnotationView *) [self.mapKitWithSMCalloutView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            if(self.customMapMarker == nil) {
                annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
            } else {
                annotationView.image = self.customMapMarker;
            }
            
            PingebAnnotation *pingebAnnotation = (PingebAnnotation*)annotation;
            annotationView.data = pingebAnnotation.data;
            annotationView.distance = pingebAnnotation.distance;
            annotationView.coordinate = pingebAnnotation.coordinate;
            annotationView.spotImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:pingebAnnotation.data.image]]];
            
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
    self.mapKitWithSMCalloutView.calloutView = calloutView;
    
    if ([annotationView isKindOfClass:[PingeborgAnnotationView class]]) {
        PingeborgAnnotationView* pingeborgAnnotationView = (PingeborgAnnotationView *)annotationView;
        
        PingeborgCalloutView* pingeborgCalloutView = [[PingeborgCalloutView alloc] init];
        pingeborgCalloutView.title.text = pingeborgAnnotationView.data.displayName;
        pingeborgCalloutView.distance.text = pingeborgAnnotationView.distance;
        pingeborgCalloutView.coordinate = pingeborgAnnotationView.coordinate;
        
        //set button image to blue
        pingeborgCalloutView.button.imageView.image = [pingeborgCalloutView.button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [pingeborgCalloutView.button.imageView setTintColor:[UIColor blueColor]];
        
        //insert image
        if(pingeborgAnnotationView.spotImage != nil) {
            UIImage *scaledImage = [self imageWithImage:pingeborgAnnotationView.spotImage
                                       scaledToMaxWidth:pingeborgCalloutView.frame.size.width
                                              maxHeight:700];
            UIImageView *spotImageView = [[UIImageView alloc] initWithImage:scaledImage];
            [spotImageView setContentMode: UIViewContentModeScaleAspectFit];
            [pingeborgCalloutView addSubview:spotImageView];
            
            //move image under the other subviews
            CGRect spotImageViewRect = spotImageView.frame;
            spotImageViewRect.origin.y += pingeborgCalloutView.frame.size.height + 10;
            [spotImageView setFrame: spotImageViewRect];
            
            CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
            pingeborgCalloutViewRect.size.height = pingeborgCalloutViewRect.size.height + spotImageView.frame.size.height + 10;
            [pingeborgCalloutView setFrame: pingeborgCalloutViewRect];
        }
        
        if ( ![pingeborgAnnotationView.data.descriptionOfSpot isEqualToString:@""] ) {
            UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pingeborgCalloutView.frame.size.width, 50)];
            descriptionLabel.text = pingeborgAnnotationView.data.descriptionOfSpot;
            [descriptionLabel setFont:[descriptionLabel.font fontWithSize:14]];
            [descriptionLabel setTextColor:[UIColor grayColor]];
            [descriptionLabel setNumberOfLines:2];
            [descriptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [descriptionLabel setContentMode: UIViewContentModeTopLeft];
            
            //move label under the other subviews
            CGRect descriptionLabelRect = descriptionLabel.frame;
            descriptionLabelRect.origin.y += pingeborgCalloutView.frame.size.height + 10;
            [descriptionLabel setFrame: descriptionLabelRect];
            
            //extend pingeCalloutView
            CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
            pingeborgCalloutViewRect.size.height = pingeborgCalloutViewRect.size.height + descriptionLabel.frame.size.height + 10;
            [pingeborgCalloutView setFrame: pingeborgCalloutViewRect];
            
            [pingeborgCalloutView addSubview:descriptionLabel];
        }
        
        pingeborgCalloutView.descriptionOfSpot.text = pingeborgAnnotationView.data.descriptionOfSpot;
        [pingeborgCalloutView.button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapNavigationTapped)]];
        calloutView.contentView = pingeborgCalloutView;
        
        // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
        calloutView.calloutOffset = annotationView.calloutOffset;
        
        // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
        
        // This does all the magic.
        [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.view animated:YES];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [self.mapKitWithSMCalloutView.calloutView dismissCalloutAnimated:YES];
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


- (void)mapNavigationTapped {
    PingeborgCalloutView *pingeborgCalloutView = (PingeborgCalloutView* )self.mapKitWithSMCalloutView.calloutView.contentView;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pingeborgCalloutView.coordinate addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = pingeborgCalloutView.title.text;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:launchOptions];
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

- (void)pingeborgSystemChanged {
}

@end
