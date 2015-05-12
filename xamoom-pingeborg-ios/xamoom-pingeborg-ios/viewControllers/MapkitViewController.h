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
#import "FeedItemCell.h"
#import "ArtistDetailViewController.h"
#import "UIImage+animatedGIF.h"

@class CustomMapView;

@interface MapkitViewController : UIViewController <MKMapViewDelegate, SMCalloutViewDelegate, CLLocationManagerDelegate, XMMEnduserApiDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *geofenceView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *geoFenceActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *geoFenceIcon;
@property (weak, nonatomic) IBOutlet UILabel *geoFenceLabel;

@property (nonatomic, strong) CustomMapView *mapKitWithSMCalloutView;
@property (nonatomic, strong) MKPointAnnotation *annotationForSMCalloutView;

@property CLLocationManager *locationManager;
@property CLLocation *lastLocation;

@property UIImage *customMapMarker;
@property SVGKImage *customSVGMapMarker;
@property NSMutableArray *itemsToDisplay;
@property NSMutableDictionary *imagesToDisplay;

@end