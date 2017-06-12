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
 * XMMContentBlock can have 9 different types (see blockType).
 * Every contentBlock are localized and only uses some of the properties.
 */
@interface XMMContentBlock : JSONAPIResourceBase  <XMMRestResource>

/**
 * The title of this contentBlock.
 */
@property (nonatomic, copy) NSString *title;
/**
 * The publicStatus of the content. Yes means public.
 * Changed on our system when check "mobile-only" on the contentBlock.
 */
@property (nonatomic) BOOL publicStatus;
/**
 * The contentBlockType (0-9) determining the type of the contentBlock.
 */
@property (nonatomic) int blockType;

@property (nonatomic) NSString *text;

@property (nonatomic) NSString *artists;

@property (nonatomic) NSString *fileID;

@property (nonatomic) NSString *soundcloudUrl;

@property (nonatomic) int linkType;

@property (nonatomic) NSString *linkUrl;

@property (nonatomic) NSString *contentID;

@property (nonatomic) int downloadType;

@property (nonatomic) NSArray *spotMapTags;

@property (nonatomic) double scaleX;

@property (nonatomic) NSString *videoUrl;

@property (nonatomic) BOOL showContent;
/**
 * Alternative text for images.
 */
@property (nonatomic) NSString *altText;

@property (nonatomic) NSString *copyright;

@end
