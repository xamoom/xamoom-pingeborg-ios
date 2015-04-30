//
//  MapkitViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 01/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SVGKit.h>
#import <SVGKSourceString.h>
#import "XMMEnduserApi.h"
#import "Globals.h"
#import "SMCalloutView.h"
#import "PingeborgAnnotationView.h"
#import "PingeborgCalloutView.h"

@class CustomMapView;

@interface MapkitViewController : UIViewController <MKMapViewDelegate, SMCalloutViewDelegate, CLLocationManagerDelegate, XMMEnderuserApiDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomMapView *mapKitWithSMCalloutView;
@property (nonatomic, strong) MKPointAnnotation *annotationForSMCalloutView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *geofenceView;

@property CLLocationManager *locationManager;

@property UIImage *customMapMarker;
@property SVGKImage *customSVGMapMarker;
@property NSMutableArray *itemsToDisplay;

@end
