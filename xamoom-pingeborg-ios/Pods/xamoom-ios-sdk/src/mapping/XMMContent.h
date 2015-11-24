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
 * `XMMContent` is used for mapping the JSON sended by the api.
 */
@interface XMMContent : NSObject

#pragma mark Properties
/// @name Properties
/**
 * The unique contentId on our system.
 */
@property (nonatomic, copy) NSString *contentId;
/**
 * Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *imagePublicUrl;
/**
 * Description (Excerpt) of the content.
 */
@property (nonatomic, copy) NSString *descriptionOfContent;
/**
 * The language of the content
 */
@property (nonatomic, copy) NSString *language;
/**
 * The title of the content.
 */
@property (nonatomic, copy) NSString *title;
/**
 * Array containing items of XMMContentBlock.
 * Display all different contentBlocks.
 */
@property (nonatomic) NSArray *contentBlocks;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContent` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns the `XMMCoreDataContentBlocks` in the right order.
 *
 * @return NSArray*
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *sortedContentBlocks;

@end
