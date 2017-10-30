//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMCDContent.h"
#import "XMMCDSpot.h"

@implementation XMMCDContent

@dynamic jsonID;
@dynamic title;
@dynamic imagePublicUrl;
@dynamic contentDescription;
@dynamic language;
@dynamic contentBlocks;
@dynamic category;
@dynamic tags;
@dynamic system;
@dynamic customMeta;
@dynamic sharingUrl;
@dynamic toDate;
@dynamic fromDate;
@dynamic relatedSpot;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  return [self insertNewObjectFrom:entity
                       fileManager:[[XMMOfflineFileManager alloc] init]];
}

+ (instancetype)insertNewObjectFrom:(id)entity fileManager:(XMMOfflineFileManager *)fileManager {
  return [self insertNewObjectFrom:entity fileManager:fileManager completion:nil];
}

+ (instancetype)insertNewObjectFrom:(id)entity
                        fileManager:(XMMOfflineFileManager *)fileManager
                         completion:(void(^)(NSString *url, NSData *data, NSError *error))completion {
  XMMContent *content = (XMMContent *)entity;
  XMMCDContent *savedContent = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:content.ID];
  if (objects.count > 0) {
    savedContent = objects.firstObject;
  } else {
    savedContent = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                 inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedContent.jsonID = content.ID;
  
  if (content.contentBlocks != nil) {
    NSMutableOrderedSet *contentBlocks = [[NSMutableOrderedSet alloc] init];
    for (XMMContentBlock *block in content.contentBlocks) {
      [contentBlocks addObject:[XMMCDContentBlock insertNewObjectFrom:block
                                                          fileManager:fileManager
                                                           completion:completion]];
    }
    savedContent.contentBlocks = contentBlocks;
  }
  
  if (content.system != nil) {
    savedContent.system = [XMMCDSystem insertNewObjectFrom:content.system];
  }
  savedContent.title = content.title;
  savedContent.imagePublicUrl = content.imagePublicUrl;
  if (content.imagePublicUrl) {
    [fileManager saveFileFromUrl:content.imagePublicUrl completion:completion];
  }
  if (content.relatedSpot != nil) {
    savedContent.relatedSpot = [XMMCDSpot insertNewObjectFrom:content.relatedSpot];
  }
  savedContent.contentDescription = content.contentDescription;
  savedContent.language = content.language;
  savedContent.category = [NSNumber numberWithInt:content.category];
  savedContent.tags = content.tags;
  savedContent.customMeta = content.customMeta;
  savedContent.sharingUrl = content.sharingUrl;
  savedContent.toDate = content.toDate;
  savedContent.fromDate = content.fromDate;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedContent;
}

@end
