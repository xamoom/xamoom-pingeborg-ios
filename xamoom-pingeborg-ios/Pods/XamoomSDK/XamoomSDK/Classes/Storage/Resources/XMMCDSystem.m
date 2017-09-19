//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMCDSystem.h"

@implementation XMMCDSystem

@dynamic jsonID;
@dynamic name;
@dynamic url;
@dynamic setting;
@dynamic style;
@dynamic menu;

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
  XMMSystem *system = (XMMSystem *)entity;
  XMMCDSystem *savedSystem = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:system.ID];
  if (objects.count > 0) {
    savedSystem = objects.firstObject;
  } else {
    savedSystem = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSystem.jsonID = system.ID;
  savedSystem.name = system.name;
  savedSystem.url = system.url;
  
  if (system.setting != nil) {
    savedSystem.setting = [XMMCDSystemSettings insertNewObjectFrom:system.setting];
  }
  
  if (system.menu != nil) {
    savedSystem.menu = [XMMCDMenu insertNewObjectFrom:system.menu];
  }
  
  if (system.style != nil) {
    savedSystem.style = [XMMCDStyle insertNewObjectFrom:system.style];
  }
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedSystem;
}

@end
