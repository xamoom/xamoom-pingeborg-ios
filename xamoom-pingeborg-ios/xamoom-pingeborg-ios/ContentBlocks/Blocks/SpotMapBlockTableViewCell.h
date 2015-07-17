//
//  SpotMapBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SVGKit.h>
#import <SVGKSourceString.h>
#import "XMMEnduserApi.h"
#import "XMMAnnotation.h"
#import "XMMAnnotationView.h"
#import "XMMCalloutView.h"
#import <SMCalloutView/SMCalloutView.h>

@class XamoomMapView;

@interface SpotMapBlockTableViewCell : UITableViewCell <MKMapViewDelegate, SMCalloutViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) XamoomMapView *mapKitWithSMCalloutView;
@property NSArray *spotMapTags; 
@property UIImage *customMapMarker;
@property SVGKImage *customSVGMapMarker;
@property CLLocationManager *locationManager;

- (void)getSpotMapWithSystemId:(NSString*)systemId withLanguage:(NSString*)language;

@end
