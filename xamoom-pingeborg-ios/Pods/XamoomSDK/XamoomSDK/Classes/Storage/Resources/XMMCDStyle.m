//
//  XMMCDStyle.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
