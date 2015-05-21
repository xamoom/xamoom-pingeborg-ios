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

@property XMMResponseGetSpotMapItem *data;
@property NSString *distance;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString*)name withLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) MKMapItem *mapItem;

@end
