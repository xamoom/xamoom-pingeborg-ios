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
#import "XMMResponseContent.h"

@class XMMResponseStyle;
@class XMMResponseMenuItem;

/**
 `XMMResponseGetByLocationIdentifier` is used for mapping the JSON sended by the api.
 */
@interface XMMResponseGetByLocationIdentifier : NSObject

/**
 The systemName on our system.
 */
@property (nonatomic, copy) NSString *systemName;
/**
 Url to the homepage.
 */
@property (nonatomic, copy) NSString *systemUrl;
/**
 The unique systemId on our system.
 */
@property (nonatomic, copy) NSString *systemId;
/**
 Bool to determine if there is a XMMResponseContent linked to the locationIdentifier on our system.
 */
@property (nonatomic) BOOL hasContent;
/**
 Bool to determine if there is a Spot linked to the locationIdentifier on our system.
 */
@property (nonatomic) BOOL hasSpot;
/**
 The content as XMMResponseContent to display.
 */
@property (nonatomic) XMMResponseContent *content;
/**
 The style of the system as XMMResponseStyle.
 */
@property (nonatomic) XMMResponseStyle *style;
/**
 Array containing items of XMMResponseMenuItem.
 */
@property (nonatomic) NSArray *menu;

/// @name Mapping

/**
 Returns a RKResponseDescriptor for `XMMResponseGetByLocationIdentifier` class.
 
 @return RKResponseDescriptor*
 */
+ (RKResponseDescriptor*)contentDescriptor;

@end
