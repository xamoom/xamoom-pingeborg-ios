//
//  SpotMapBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"
#import "PingebAnnotation.h"
#import "PingeborgAnnotationView.h"

@interface SpotMapBlockTableViewCell : UITableViewCell <MKMapViewDelegate, XMMEnderuserApiDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property NSString *spotMapTags;
@property UIImage *customMapMarker;

- (void)getSpotMap;

@end
