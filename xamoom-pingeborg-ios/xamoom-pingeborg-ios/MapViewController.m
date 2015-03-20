//
//  MapViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 11/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MKAnnotation.h>
#import "PingebAnnotation.h"
#import "PingeborgAnnotationView.h"

@interface MapViewController ()

@end

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
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 46.6247222;
    region.center.longitude = 14.3052778;
    region.span.longitudeDelta = 0.09f;
    region.span.longitudeDelta = 0.09f;
    [self.mapView setRegion:region animated:YES];
}

- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        point.title = item.displayName;
        point.image = item.image;
        
        CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
        point.subtitle = [NSString stringWithFormat:@"Entfernung: %d Meter", (int)distance];

        [self.mapView addAnnotation:point];
    }
}

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
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
            
            /*
            UIImageView *imageView = [[UIImageView alloc] init];
            PingebAnnotation *pinAnnotation = annotation;
            NSURL *url = [NSURL URLWithString:pinAnnotation.image];
            NSData *data = [NSData dataWithContentsOfURL:url];
            imageView.image = [UIImage imageWithData:data];
            
            annotationView.leftCalloutAccessoryView = imageView;
            */
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightButton setFrame:CGRectMake(0,0,50,50)];
            [rightButton setImage:[[UIImage imageNamed:@"direction"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setTintColor:[UIColor whiteColor]];
            [rightButton setBackgroundColor:[UIColor blueColor]];
            [rightButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
            annotationView.rightCalloutAccessoryView = rightButton;
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

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Hellyeah");
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"PingeborgCalloutView" owner:self options:nil];
    PingeborgAnnotationView *mainView = [subviewArray objectAtIndex:0];
    mainView.center = CGPointMake(view.bounds.size.width*0.5f, -mainView.bounds.size.height*0.5f);
    
    // border radius
    [mainView.layer setCornerRadius:30.0f];
    
    // border
    [mainView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [mainView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [mainView.layer setShadowColor:[UIColor blackColor].CGColor];
    [mainView.layer setShadowOpacity:0.8];
    [mainView.layer setShadowRadius:3.0];
    [mainView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [view addSubview:mainView];
}
 */

/*
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSArray *subviews = view.subviews;
    [subviews[0] removeFromSuperview];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
