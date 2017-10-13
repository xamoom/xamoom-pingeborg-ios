//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


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

@property (nonatomic) NSArray *contentListTags;

@property (nonatomic) int contentListPageSize;

@property (nonatomic) BOOL contentListSortAsc;

@end
