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
#import "XMMContent.h"
#import "XMMSystem.h"
#import "XMMMarker.h"

@class XMMContent;

/**
 * XMMSpot is localized.
 */
@interface XMMSpot : JSONAPIResourceBase  <XMMRestResource>

/**
 * The displayName of the spot.
 */
@property (nonatomic, copy) NSString *name;
/**
 * The description of the spot. (E.g. "on the front door of the xamoom office")
 */
@property (nonatomic, copy) NSString *spotDescription;
/**
 * The latitude of the spot
 */
@property (nonatomic) double latitude;
/**
 * The longitude of the spot
 */
@property (nonatomic) double longitude;
/**
 * Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *image;
/**
 *  Category as an number to specify an icon.
 */
@property (nonatomic) int category;
/**
 *  Dictionary with keys "lat" and "lon".
 */
@property (nonatomic) NSMutableDictionary *locationDictionary;
/**
 *  NSArray containing all tags of the spot.
 */
@property (nonatomic) NSArray *tags;
/**
 * Custom meta as dictionary.
 */
@property (nonatomic) NSDictionary *customMeta;
/**
 *  Linked content to the spot.
 */
@property (nonatomic) XMMContent *content;
/**
 * Linked markers to the spot.
 */
@property (nonatomic) NSArray *markers;
/**
 *  System from the spot.
 */
@property (nonatomic) XMMSystem *system;

/**
 * Save this entity for offline use with callback for downloaded files.  
 *
 * @param downloadCompletion Completion block called after finishing download
 * - *param1* url Url of the saved file
 * - *param1* data Data of the saved file
 * - *param2* error NSError, can be null
 */
- (id<XMMCDResource>)saveOffline:(void (^)(NSString *url, NSData *data, NSError *error))downloadCompletion;

@end

