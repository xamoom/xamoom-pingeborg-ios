//
// Copyright 2015 by Raphael Seher <raphael@xamoom.com>
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

@property (nonatomic, copy) NSString *systemName;
@property (nonatomic, copy) NSString *systemUrl;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *descriptionOfContent;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic) float lat;
@property (nonatomic) float lon;
@property (nonatomic, copy) NSString *foregroundFontColor;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *highlightFontColor;
@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *spotName;
@property (nonatomic, copy) NSString *contentName;

/// @name Mapping

/**
 Returns a RKObjectMapping for `XMMResponseGetByLocationItem` class.
 
 @return RKObjectMapping*
 */
+ (RKObjectMapping*)mapping;

@end
