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

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;

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
    [mapView setRegion:region animated:YES];
    
}

- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    
    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        point.title = item.displayName;
        //point.subtitle = item.descriptionOfContent;
        [self.mapView addAnnotation:point];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //do not touch userLocation
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //change mapMarker
    MKAnnotationView* aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PingebAnnotation"];
    aView.image = [UIImage imageNamed:@"Map"];
    aView.canShowCallout = YES;
    
    
    // Image and two labels
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.backgroundColor = [UIColor greenColor];
    imageView.image = [UIImage imageNamed:@"Map"];
    
    //aView.leftCalloutAccessoryView = imageView;
    aView.annotation = annotation;
    
    //aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return aView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
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
