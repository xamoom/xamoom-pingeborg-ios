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
#import "XMMContentBlock.h"
#import "XMMContentBlock6TableViewCell.h"

/**
 * `XMMContentBlockType6` is used for mapping the JSON sended by the api.
 *
 * This class represents the contentBlockType 'CONTENT'.
 *
 * *Default behavior*
 *
 * 1. Load via [XMMEnduserApi contentWithContentId:includeStyle:includeMenu:withLanguage:full:completion:error:]
 * 2. Display tile, image and descriptionOfContent
 * 3. Open new content on user interaction
 */
@interface XMMContentBlockType6 : XMMContentBlock

/*
 * The unique contentId on our system.
 **/
@property (nonatomic, copy) NSString *contentId;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContentBlockType6` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns a RKObjectMappingMatcher for `XMMContentBlockType6` class.
 *
 * @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end

@interface XMMContentBlockType6 (XMMTableViewRepresentation)

- (UITableViewCell *)tableView: (UITableView *)tableView representationAsCellForRowAtIndexPath: (NSIndexPath *)indexPath;

@end