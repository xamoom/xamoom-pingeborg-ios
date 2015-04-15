//
//  PingebAnnotation.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "PingebAnnotation.h"
#import <MapKit/MapKit.h>

@implementation PingebAnnotation

@synthesize coordinate;
@synthesize title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    
    return self;
}

- (id)initWithName:(NSString*)name location:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = name;
    }
    
    return self;
}

- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];

    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end