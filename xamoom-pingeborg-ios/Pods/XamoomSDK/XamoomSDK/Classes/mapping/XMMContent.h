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
#import "XMMSystem.h"
#import "XMMSpot.h"
#import "XMMContentBlock.h"
#import "NSDate+ISODate.h"

@class XMMSpot;

/**
 * XMMContent is localized and containts the different blocks saved
 * in contentBlocks.
 */
@interface XMMContent : JSONAPIResourceBase  <XMMRestResource>

#pragma mark Properties

@property (nonatomic, copy) NSString *title;
/**
 * Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *imagePublicUrl;
/**
 * Description (Excerpt) of the content.
 */
@property (nonatomic, copy) NSString *contentDescription;
/**
 * The language of the content
 */
@property (nonatomic, copy) NSString *language;
/**
 * Array containing items of XMMContentBlock.
 */
@property (nonatomic) NSArray *contentBlocks;
/**
 *  Category as an number to specify an icon.
 */
@property (nonatomic) int category;
/**
 * Tags set in backend.
 */
@property (nonatomic) NSArray *tags;
/**
 * Custom meta as dictionary.
 */
@property (nonatomic) NSDictionary *customMeta;
/**
 * Connected XMMSystem.
 */
@property (nonatomic) XMMSystem *system;
/**
 * Connected XMMSpot.
 */
@property (nonatomic) XMMSpot *spot;

@property (nonatomic) NSString *sharingUrl;
@property (nonatomic) XMMSpot *relatedSpot;
@property (nonatomic) NSDate *toDate;
@property (nonatomic) NSDate *fromDate;

/**
 * Save this entity for offline use with callback for downloaded files.
 *
 * @param downloadCompletion Completion block called after finishing download
 * - *param1* url Url of the saved file
 * - *param1* data Data of the saved file
 * - *param2* error NSError, can be null
 */
- (id<XMMCDResource>)saveOffline:(void (^)(NSString *url, NSData *data, NSError *error))downloadCompletion;

@end
