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

@class XMMStyle;
@class XMMContent;

/**
 * `XMMContentById` is used for mapping the JSON sended by the api.
 */
@interface XMMContentById : NSObject

/**
 * The systemName on our system.
 */
@property (nonatomic, copy) NSString *systemName;
/**
 * Url to the homepage.
 */
@property (nonatomic, copy) NSString *systemUrl;
/**
 * The unique systemId on our system.
 */
@property (nonatomic, copy) NSString *systemId;
/**
 * The content as XMMContent to display.
 */
@property (nonatomic) XMMContent *content;
/**
 * Array containing items of XMMMenuItem.
 */
@property (nonatomic) NSArray *menu;
/**
 * The style of the system as XMMStyle.
 */
@property (nonatomic) XMMStyle* style;

/// @name Mapping

/**
 * Returns a RKResponseDescriptor for `XMMContentById` class.
 *
 * @return RKResponseDescriptor*
 */
+ (RKResponseDescriptor*)contentDescriptor;

@end

