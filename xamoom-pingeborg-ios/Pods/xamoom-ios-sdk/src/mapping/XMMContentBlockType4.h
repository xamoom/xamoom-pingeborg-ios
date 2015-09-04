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
 * `XMMContentBlockType4` is used for mapping the JSON sended by the api.
 *
 * This class represents the contentBlockType 'LINK'.
 *
 * *Default behavior*
 *
 * 1. On the left a icon according to type
 * 2. Next to the image title and below text
 * 3. Backgroundcolor according to type
 *
 * Example implementation is on our sample app "pingeb.org" https://github.com/xamoom/xamoom-pingeborg-ios
 */
@interface XMMContentBlockType4 : XMMContentBlock

/**
 * A url inputed by the user.
 */
@property (nonatomic, copy) NSString *linkUrl;
/**
 * Text as description for the url.
 */
@property (nonatomic, copy) NSString *text;
/**
 * Link type to determine the type of the link.
 *
 * - FACEBOOK = 0
 * - TWITTER = 1
 * - WEB = 2
 * - AMAZON = 3
 * - WIKIPEDIA = 4
 * - LINKEDIN = 5
 * - FLICKR = 6
 * - SOUNDCLOUD = 7
 * - ITUNES = 8
 * - YOUTUBE = 9
 * - GOOGLEPLUS = 10
 * - TEL = 11
 * - EMAIL = 12
 * - SPOTIFY = 13
 * - GOOGLE_MAPS = 14
 * - ITUNES_APP = 15
 * - GOOGLE_PLAY = 16
 * - WINDOWS_STORE = 17
 */
@property (nonatomic) int linkType;

/// @name Mapping

/**
 * Returns a RKObjectMapping for `XMMContentBlockType4` class.
 *
 * @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 * Returns a RKObjectMappingMatcher for `XMMContentBlockType4` class.
 *
 * @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end
