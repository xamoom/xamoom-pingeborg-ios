//
//  XMMCDContent.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
  savedContent.contentDescription = content.contentDescription;
  savedContent.language = content.language;
  savedContent.category = [NSNumber numberWithInt:content.category];
  savedContent.tags = content.tags;
  savedContent.customMeta = content.customMeta;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedContent;
}

@end
