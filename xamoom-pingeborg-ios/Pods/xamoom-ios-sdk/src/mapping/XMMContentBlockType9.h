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

/**
 * `XMMContentBlockType9` is used for mapping the JSON sended by the api.
 *
 * This class represents the contentBlockType 'SPOTMAP'.
 *
 * *Default behavior*
 *
 * 1. Display a map with the spot-markers on it.
 */
@interface XMMContentBlockType9 : XMMContentBlock

/**
 * String of comma seperated tags to display spotmap.
 *
 * Call [XMMEnduserApi spotMapWithMapTags:withLanguage:completion:error:] with the spotMapTags.
 */
@property (nonatomic, copy) NSString *spotMapTag;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContentBlockType9` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns a RKObjectMappingMatcher for `XMMContentBlockType9` class.
 *
 * @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end
