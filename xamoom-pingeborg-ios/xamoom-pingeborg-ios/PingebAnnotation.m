//
//  PingebAnnotation.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 13/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "PingebAnnotation.h"

@implementation PingebAnnotation

@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
