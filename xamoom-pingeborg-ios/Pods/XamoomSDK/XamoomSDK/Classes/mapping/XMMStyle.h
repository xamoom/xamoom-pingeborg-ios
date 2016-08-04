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

/**
 * XMMStyle with colors and icons.
 */
@interface XMMStyle : JSONAPIResourceBase  <XMMRestResource>

/**
 * The background color defined on our system. (E.g. #f5f5f5)
 */
@property (nonatomic, copy) NSString* backgroundColor;
/**
 * The hightLightFontColor defined on our system. Used for links. (E.g. #ff0000)
 */
@property (nonatomic, copy) NSString* highlightFontColor;
/**
 * The foregroundFont color defined on our system. (E.g. #f9f9f9)
 */
@property (nonatomic, copy) NSString* foregroundFontColor;
/**
 * The chromeHeaderColor is displayed on mobile chrome browser as the "head".
 * Use it for your e.g. navigation bar. (E.g. #cdcdcd)
 */
@property (nonatomic, copy) NSString* chromeHeaderColor;
/**
 * The customMarker as DOUBLE base64 encoded string. Use this one on maps.
 */
@property (nonatomic, copy) NSString* customMarker;
/**
 * The icon as DOUBLE base64 encoded string.
 */
@property (nonatomic, copy) NSString* icon;

/**
 * Create style instance with defined colors;
 *
 * @param backgroundHexColor Hex of backgroundColor;
 * @param highlightFontHexColor Hex of hightlightColor (used for e.g. links)
 * @param foregroundFontHexColor Hex of textColor
 */
- (instancetype)initWithBackgroundColor:(NSString *)backgroundHexColor highlightTextColor:(NSString *)highlightFontHexColor textColor:(NSString *)foregroundFontHexColor;

@end
