//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

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