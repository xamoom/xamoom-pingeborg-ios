//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"
#import "XMMOfflineStorageManager.h"
#import "XMMSimpleStorage.h"

/**
 * Use the XMMOfflineStorageTagModule to have a managed way to download and
 * delete spots and their contents.
 * This supports to download and delete spots and contents by using the tags
 * of the spots. The module will save what tags are saved and when you delete 
 * by tags it will check to delete only spots and contents that are save to 
 * delete.
 */
@interface XMMOfflineStorageTagModule : NSObject

@property (strong, nonatomic, nonnull) XMMEnduserApi *api;
@property (strong, nonatomic, nonnull) XMMOfflineStorageManager *storeManager;
@property (strong, nonatomic, nonnull, readonly) NSMutableArray *offlineTags;
@property (strong, nonatomic, nonnull) XMMSimpleStorage *simpleStorage;

/**
 * Constructor needs a valid api to download from cloud.
 *
 * @param api XMMEnduserApi instance.
 */
- (nonnull instancetype)initWithApi:(nonnull XMMEnduserApi *)api;


/**
 * This will download all spots that have the provided tags. It will also
 * download all the connected contents and all media files used.
 *
 * @param tags NSArray of NSString tags.
 * @param downloadCompletion Completionblock for downloaded file.
 * @param completion Completionblock when all spots & contents are downloaded.
 */
- (void)downloadAndSaveWithTags:(nonnull NSArray *)tags
             downloadCompletion:(nullable void (^)(NSString * _Null_unspecified url, NSData * _Null_unspecified data, NSError * _Null_unspecified error))downloadCompletion
                     completion:(nullable void (^)( NSArray * _Null_unspecified spots , NSError * _Null_unspecified error))completion;

/**
 * Delete downloaded data by tags. This will check what spots, contents and files
 * are secure to delete (unused by other spots/contents) and deletes them.
 *
 * @param tags Tags to delete.
 * @return NSError Error if something goes wrong.
 */
- (nullable NSError *)deleteSavedDataWithTags:(nonnull NSArray *)tags;

@end
