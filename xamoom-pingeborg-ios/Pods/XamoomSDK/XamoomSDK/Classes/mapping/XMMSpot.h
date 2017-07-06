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
#import "XMMContent.h"
#import "XMMSystem.h"
#import "XMMMarker.h"

@class XMMContent;

/**
 * XMMSpot is localized.
 */
@interface XMMSpot : JSONAPIResourceBase  <XMMRestResource>

/**
 * The displayName of the spot.
 */
@property (nonatomic, copy) NSString *name;
/**
 * The description of the spot. (E.g. "on the front door of the xamoom office")
 */
@property (nonatomic, copy) NSString *spotDescription;
/**
 * The latitude of the spot
 */
@property (nonatomic) double latitude;
/**
 * The longitude of the spot
 */
@property (nonatomic) double longitude;
/**
 * Public url pointing to an image on our system.
 */
@property (nonatomic, copy) NSString *image;
/**
 *  Category as an number to specify an icon.
 */
@property (nonatomic) int category;
/**
 *  Dictionary with keys "lat" and "lon".
 */
@property (nonatomic) NSMutableDictionary *locationDictionary;
/**
 *  NSArray containing all tags of the spot.
 */
@property (nonatomic) NSArray *tags;
/**
 * Custom meta as dictionary.
 */
@property (nonatomic) NSDictionary *customMeta;
/**
 *  Linked content to the spot.
 */
@property (nonatomic) XMMContent *content;
/**
 * Linked markers to the spot.
 */
@property (nonatomic) NSArray *markers;
/**
 *  System from the spot.
 */
@property (nonatomic) XMMSystem *system;

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

