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
 * `XMMContentBlockType5` is used for mapping the JSON sended by the api.
 *
 * This class represents the contentBlockType 'EBOOK'.
 *
 * *Default behavior*
 *
 * 1. Display like a link block with another icon
 *
 * Example implementation is on our sample app "pingeb.org" https://github.com/xamoom/xamoom-pingeborg-ios
 */
@interface XMMContentBlockType5 : XMMContentBlock

/**
 * Url to a ebook file (epub, mobi, pdf).
 */
@property (nonatomic, copy) NSString *fileId;
/**
 * The name of the artist(s).
 */
@property (nonatomic, copy) NSString *artist;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContentBlockType5` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns a RKObjectMappingMatcher for `XMMContentBlockType5` class.
 *
 * @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end
