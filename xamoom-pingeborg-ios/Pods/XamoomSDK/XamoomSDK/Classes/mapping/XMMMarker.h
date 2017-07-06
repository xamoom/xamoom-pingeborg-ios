//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <JSONAPI/JSONAPIResourceBase.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import <JSONAPI/JSONAPIPropertyDescriptor.h>
#import "XMMRestResource.h"

/**
 * Marker from the xamoom cloud.
 *
 * Markers are the representation of the physical part (qr, nfc, beacon) in the
 * xamoom cloud. 
 * Every marker is connected to one XMMSpot.
 */
@interface XMMMarker : JSONAPIResourceBase  <XMMRestResource>

@property (nonatomic) NSString *qr;
@property (nonatomic) NSString *nfc;
@property (nonatomic) NSString *beaconUUID;
@property (nonatomic) NSString *beaconMajor;
@property (nonatomic) NSString *beaconMinor;
@property (nonatomic) NSString *eddyStoneUrl;

@end
