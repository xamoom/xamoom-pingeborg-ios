//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"

@class XMMSpot;

/**
 * XMMAnnotation will be used to by XMMContentBlock9TableViewCell to create the map annotations.
 */
@interface XMMAnnotation : NSObject <MKAnnotation>

@property XMMSpot *spot;
@property NSString *distance;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString*)name withLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) MKMapItem *mapItem;

@end
