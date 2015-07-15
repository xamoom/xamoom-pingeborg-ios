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

@class CustomMapView2;

@interface SpotMapBlockTableViewCell : UITableViewCell <MKMapViewDelegate, SMCalloutViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, strong) CustomMapView2 *mapKitWithSMCalloutView;
@property NSArray *spotMapTags; 
@property UIImage *customMapMarker;
@property SVGKImage *customSVGMapMarker;

- (void)getSpotMapWithSystemId:(NSString*)systemId withLanguage:(NSString*)language;

@end
