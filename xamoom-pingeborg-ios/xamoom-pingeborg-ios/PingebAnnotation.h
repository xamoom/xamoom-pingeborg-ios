//
//  PingebAnnotation.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"

@interface PingebAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property XMMResponseGetSpotMapItem *data;
@property NSString *distance;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

- (id)initWithName:(NSString*)name location:(CLLocationCoordinate2D)coord;

- (MKMapItem*)mapItem;

@end
