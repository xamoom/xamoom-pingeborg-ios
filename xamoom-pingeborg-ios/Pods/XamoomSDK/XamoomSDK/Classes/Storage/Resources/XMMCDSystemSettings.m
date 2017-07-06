//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMCDSystemSettings.h"

@implementation XMMCDSystemSettings

@dynamic jsonID;
@dynamic googlePlayId;
@dynamic itunesAppId;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  return [self insertNewObjectFrom:entity fileManager:[[XMMOfflineFileManager alloc] init]];
}

+ (instancetype)insertNewObjectFrom:(id)entity fileManager:(XMMOfflineFileManager *)fileManager {
  return [self insertNewObjectFrom:entity fileManager:fileManager completion:nil];
}

+ (instancetype)insertNewObjectFrom:(id)entity
                        fileManager:(XMMOfflineFileManager *)fileManager
                         completion:(void (^)(NSString *url, NSData *, NSError *))completion {
  XMMSystemSettings *settings = (XMMSystemSettings *)entity;
  XMMCDSystemSettings *savedSettings = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName] jsonID:settings.ID];
  if (objects.count > 0) {
    savedSettings = objects.firstObject;
  } else {
    savedSettings = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                  inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSettings.jsonID = settings.ID;
  savedSettings.googlePlayId = settings.googlePlayAppId;
  savedSettings.itunesAppId = settings.itunesAppId;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedSettings;
}

@end
