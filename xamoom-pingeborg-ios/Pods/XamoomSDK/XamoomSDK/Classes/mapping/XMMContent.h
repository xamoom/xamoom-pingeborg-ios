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
#import "XMMSystem.h"
#import "XMMSpot.h"
#import "XMMContentBlock.h"

@class XMMSpot;

/**
 * XMMContent is localized and containts the different blocks saved
 * in contentBlocks.
 */
@interface XMMContent : JSONAPIResourceBase  <XMMRestResource>

#pragma mark Properties

@property (nonatomic, copy) NSString *title;
/**
 * Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *imagePublicUrl;
/**
 * Description (Excerpt) of the content.
 */
@property (nonatomic, copy) NSString *contentDescription;
/**
 * The language of the content
 */
@property (nonatomic, copy) NSString *language;
/**
 * Array containing items of XMMContentBlock.
 */
@property (nonatomic) NSArray *contentBlocks;
/**
 *  Category as an number to specify an icon.
 */
@property (nonatomic) int category;
/**
 * Tags set in backend.
 */
@property (nonatomic) NSArray *tags;
/**
 * Custom meta as dictionary.
 */
@property (nonatomic) NSDictionary *customMeta;
/**
 * Connected XMMSystem.
 */
@property (nonatomic) XMMSystem *system;
/**
 * Connected XMMSpot.
 */
@property (nonatomic) XMMSpot *spot;

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
