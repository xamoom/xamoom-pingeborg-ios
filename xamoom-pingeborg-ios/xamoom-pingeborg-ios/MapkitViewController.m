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

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init map
    self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.view.bounds];
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
    
    if ( self.mapKitWithSMCalloutView.annotations.count <= 0 ) {
        [[XMMEnduserApi sharedInstance] setDelegate:self];
        [[XMMEnduserApi sharedInstance] getSpotMapWithSystemId:[Globals sharedObject].globalSystemId withMapTags:@"showAllTheSpots" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - XMMEnduser Delegate

- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    if (result.style.customMarker != nil) {
        NSString *base64String = result.style.customMarker;
        
        //decode two times!
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        decodedData = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
        self.customMapMarker = [self imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
        
        if (!self.customMapMarker) {
            //save svg mapmarker
            NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName = [NSString stringWithFormat:@"%@/mapmarker.svg", documentsDirectory];
            [imageData writeToFile:fileName atomically:YES];
            
            //read svg mapmarker
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
            self.customSVGMapMarker = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:
                                                                  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
        }
    }
    
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
            
            PingebAnnotation *pingebAnnotation = (PingebAnnotation*)annotation;
            annotationView.data = pingebAnnotation.data;
            annotationView.distance = pingebAnnotation.distance;
            annotationView.coordinate = pingebAnnotation.coordinate;
            
            if(pingebAnnotation.data.image != nil) {
                [self downloadImageWithURL:pingebAnnotation.data.image completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        annotationView.spotImage = image;
                    }
                }];
            }
            
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
        PingeborgCalloutView* pingeborgCalloutView = [[PingeborgCalloutView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 45.0f)];
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
        
        //NSLog(@"Label %f and %f", [pingeborgCalloutView sizeThatFits:pingeborgCalloutView.frame.size].width, [pingeborgCalloutView sizeThatFits:pingeborgCalloutView.frame.size].height);
        
        [pingeborgCalloutView addSubview:titleLabel];
        [pingeborgCalloutView addSubview:distanceLabel];
        
        UIImageView *spotImageView;
        
        //insert image
        if(pingeborgAnnotationView.spotImage != nil) {
            float imageRatio = pingeborgAnnotationView.spotImage.size.width / pingeborgAnnotationView.spotImage.size.height;
            
            spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, pingeborgCalloutView.frame.size.width, pingeborgCalloutView.frame.size.width / imageRatio)];
            
            [spotImageView setContentMode: UIViewContentModeScaleAspectFit];
            spotImageView.image = pingeborgAnnotationView.spotImage;
            
            //increase pingeborCalloutView height
            CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
            pingeborgCalloutViewRect.size.height += spotImageView.frame.size.height;
            pingeborgCalloutView.frame = pingeborgCalloutViewRect;
            
            [pingeborgCalloutView addSubview:spotImageView];
        }
        
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
            pingeborgCalloutViewRect.size.height += spotDescriptionLabel.frame.size.height;
            pingeborgCalloutView.frame = pingeborgCalloutViewRect;
            
            [pingeborgCalloutView addSubview:spotDescriptionLabel];
        }
        
        //create, design and adust button
        UIButton *navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, pingeborgCalloutView.frame.size.height, 300.0f, 60.0f)];
        navigationButton.backgroundColor = [UIColor blueColor];
        [navigationButton setImage:[[UIImage imageNamed:@"car"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [navigationButton setTintColor:[UIColor whiteColor]];
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

#pragma mark User Interaction

- (void)mapNavigationTapped {
    PingeborgCalloutView *pingeborgCalloutView = (PingeborgCalloutView* )self.mapKitWithSMCalloutView.calloutView.contentView;
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pingeborgCalloutView.coordinate addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = pingeborgCalloutView.nameOfSpot;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [mapItem openInMapsWithLaunchOptions:launchOptions];
}

#pragma mark - Image Methods

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


- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSURL *realUrl = [[NSURL alloc]initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - NavbarDropdown Delegation

- (void)pingeborgSystemChanged {
    NSLog(@"pingeborgSystemChanged");
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
