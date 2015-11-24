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
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+animatedGIF.h"
#import "SVGKit.h"
#import "XMMContentBlock.h"
#import "XMMContentBlock3TableViewCell.h"

/**
 * `XMMContentBlockType3` is used for mapping the JSON sended by the api.
 *
 * This class represents the contentBlockType 'IMAGE'.
 *
 * *Default behavior*
 *
 * 1. Display title as bold.
 * 2. Display image scaled to device width.
 */
@interface XMMContentBlockType3 : XMMContentBlock

/**
 * Url to a imageFile (jpg, png, webp, svg)
 */
@property (nonatomic, copy) NSString *fileId;

/**
 * Value to determine a x-axis (width) scaling from 0 to 100 in percent.
 * Is null when not set.
 */
@property (nonatomic, copy) NSDecimalNumber *scaleX;

/**
 * Url the user inserted in xamoom cloud. Can be nil and "".
 * Should be opened in browser.
 */
@property (nonatomic, copy) NSString *linkUrl;

/**
 * Alternative text for the image. Can be nil and "";
 * If nil or "", use the title.
 */
@property (nonatomic, copy) NSString *altText;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContentBlockType3` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns a RKObjectMappingMatcher for `XMMContentBlockType3` class.
 *
 * @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end

@interface XMMContentBlockType3 (XMMTableViewRepresentation)

- (UITableViewCell *)tableView: (UITableView *)tableView representationAsCellForRowAtIndexPath: (NSIndexPath *)indexPath;

@end