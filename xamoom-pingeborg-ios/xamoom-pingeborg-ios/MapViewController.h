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

@interface MapViewController : UIViewController <CLLocationManagerDelegate, XMMEnderuserApiDelegate, MKMapViewDelegate>

@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
