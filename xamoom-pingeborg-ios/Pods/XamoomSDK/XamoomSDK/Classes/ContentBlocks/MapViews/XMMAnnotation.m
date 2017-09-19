//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMAnnotation.h"
#import <MapKit/MapKit.h>

@implementation XMMAnnotation

@synthesize coordinate;
@synthesize title;

- (instancetype)init {
  self = [self initWithLocation:CLLocationCoordinate2DMake(0, 0)];
  return self;
}

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
  self = [super init];
  if (self) {
    coordinate = coord;
  }
  
  return self;
}

- (id)initWithName:(NSString*)name withLocation:(CLLocationCoordinate2D)coord {
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
