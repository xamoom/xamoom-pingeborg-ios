//
//  MapViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 11/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "XMMEnduserApi.h"
#import "PingebAnnotation.h"
#import "PingeborgAnnotationView.h"
#import "PingeborgCalloutView.h"
#import "SMCalloutView.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, XMMEnderuserApiDelegate, MKMapViewDelegate, SMCalloutViewDelegate>

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) SMCalloutView *calloutView;

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
