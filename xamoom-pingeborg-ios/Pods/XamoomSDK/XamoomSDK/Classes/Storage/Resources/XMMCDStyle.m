//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMCDStyle.h"

@implementation XMMCDStyle

@dynamic jsonID;
@dynamic backgroundColor;
@dynamic highlightFontColor;
@dynamic foregroundFontColor;
@dynamic chromeHeaderColor;
@dynamic customMarker;
@dynamic icon;

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
  XMMStyle *style = (XMMStyle *)entity;
  XMMCDStyle *savedStyle = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:style.ID];
  if (objects.count > 0) {
    savedStyle = objects.firstObject;
  } else {
    savedStyle = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                               inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedStyle.jsonID = style.ID;
  savedStyle.backgroundColor = style.backgroundColor;
  savedStyle.highlightFontColor = style.highlightFontColor;
  savedStyle.foregroundFontColor = style.foregroundFontColor;
  savedStyle.chromeHeaderColor = style.chromeHeaderColor;
  savedStyle.customMarker = style.customMarker;
  savedStyle.icon = style.icon;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedStyle;
}

@end
