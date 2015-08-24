//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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
#import "XMMEnduserApi.h"

/**
 
 `XMMResponseGetSpotMapItem` is used for mapping the JSON sended by the api.
 */
@interface XMMResponseGetSpotMapItem : NSObject

/**
 The displayName of the spot.
 */
@property (nonatomic, copy) NSString* displayName;
/**
 The description of the spot. (E.g. "on the front door of the xamoom office")
 */
@property (nonatomic, copy) NSString* descriptionOfSpot;
/**
 The latitude of the spot.
 */
@property (nonatomic) float lat;
/**
 The longitude of the spot.
 */
@property (nonatomic) float lon;
/**
 Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString* image;

/// @name Mapping

/**
 Returns a RKObjectMapping for `XMMResponseGetSpotMapItem` class.
 
 @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

@end
