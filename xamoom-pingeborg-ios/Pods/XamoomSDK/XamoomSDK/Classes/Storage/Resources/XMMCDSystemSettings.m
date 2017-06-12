//
//  XMMCDSystemSettings.m
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
