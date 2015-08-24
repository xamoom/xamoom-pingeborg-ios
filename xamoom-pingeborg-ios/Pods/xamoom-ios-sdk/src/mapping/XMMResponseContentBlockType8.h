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
#import "XMMResponseContentBlock.h"

/**
 `XMMResponseContentBlockType8` is used for mapping the JSON sended by the api.
 
 This class represents the contentBlockType 'DOWNLOAD'.
 
 *Default behavior*
 
 1. Display like a link block with another icon
 
 Example implementation is on our sample app "pingeb.org" https://github.com/xamoom/xamoom-pingeborg-ios
 
 */
@interface XMMResponseContentBlockType8 : XMMResponseContentBlock

/**
 Url to a file (vcf, ical)
 */
@property (nonatomic, copy) NSString *fileId;
/**
 Download type to determine the type of the download.
 
 - VCF = 0
 - ICAL = 1
 */
@property (nonatomic) int downloadType;
/**
 Text as description for the url.
 */
@property (nonatomic, copy) NSString *text;

/// @name Mapping

/**
 Returns a RKObjectMapping for `XMMResponseContentBlockType8` class.
 
 @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

/**
 Returns a RKObjectMappingMatcher for `XMMResponseContentBlockType8` class.
 
 @return RKObjectMappingMatcher*
 */
+ (RKObjectMappingMatcher*)dynamicMappingMatcher;

@end
