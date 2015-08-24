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
 `XMMResponseGetByLocationItem` is used for mapping the JSON sended by the api.
 */
@interface XMMResponseGetByLocationItem : NSObject

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
 The unique contentId on our system.
 */
@property (nonatomic, copy) NSString *contentId;
/**
 Description (Excerpt) of the content.
 */
@property (nonatomic, copy) NSString *descriptionOfContent;
/**
 The language of the content
 */
@property (nonatomic, copy) NSString *language;
/**
 The title of the content.
 */
@property (nonatomic, copy) NSString *title;
/**
 The background color defined on our system. (E.g. #f5f5f5)
 */
@property (nonatomic, copy) NSString *backgroundColor;
/**
 Latitude of the spot.
 */
@property (nonatomic) float lat;
/**
 Longitude of the spot.
 */
@property (nonatomic) float lon;
/**
 The foregroundFont color defined on our system. (E.g. #f9f9f9)
 */
@property (nonatomic, copy) NSString *foregroundFontColor;
/**
 The icon as DOUBLE base64 encoded string.
 */
@property (nonatomic, copy) NSString *icon;
/**
 The hightLightFontColor defined on our system. Used for links. (E.g. #ff0000)
 */
@property (nonatomic, copy) NSString *highlightFontColor;
/**
 Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *kind;
/**
 The unique spotId on our system.
 */
@property (nonatomic, copy) NSString *spotId;
/**
 The spotName on our system.
 */
@property (nonatomic, copy) NSString *spotName;
/**
 The contentName on our system.
 */
@property (nonatomic, copy) NSString *contentName;

/// @name Mapping

/**
 Returns a RKObjectMapping for `XMMResponseGetByLocationItem` class.
 
 @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

@end
