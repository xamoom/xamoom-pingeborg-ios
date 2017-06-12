//
//  XMMCDSpot.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDSpot.h"
#import "XMMCDContent.h"
#import "XMMOfflineFileManager.h"

@implementation XMMCDSpot

@dynamic jsonID;
@dynamic name;
@dynamic spotDescription;
@dynamic image;
@dynamic category;
@dynamic locationDictionary;
@dynamic tags;
@dynamic content;
@dynamic markers;
@dynamic system;
@dynamic customMeta;

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
  XMMSpot *spot = (XMMSpot *)entity;
  XMMCDSpot *savedSpot = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance]
                      fetch:[[self class] coreDataEntityName]
                      jsonID:spot.ID];
  if (objects.count > 0) {
    savedSpot = objects.firstObject;
  } else {
    savedSpot = [NSEntityDescription
                 insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                 inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedSpot.jsonID = spot.ID;
  
  if (spot.content != nil) {
    savedSpot.content = [XMMCDContent insertNewObjectFrom:spot.content];
  }
  
  if (spot.system != nil) {
    savedSpot.system = [XMMCDSystem insertNewObjectFrom:spot.system];
  }
  
  if (spot.markers != nil) {
    NSMutableSet *markers = [[NSMutableSet alloc] init];
    for (XMMMarker *marker in spot.markers) {
      [markers addObject:[XMMCDMarker insertNewObjectFrom:marker]];
    }
    savedSpot.markers = markers;
  }
  
  savedSpot.name = spot.name;
  savedSpot.spotDescription = spot.spotDescription;
  savedSpot.locationDictionary = spot.locationDictionary;
  savedSpot.image = spot.image;
  if (spot.image) {
    [fileManager saveFileFromUrl:spot.image completion:completion];
  }
  savedSpot.category = [NSNumber numberWithInt:spot.category];
  savedSpot.tags = spot.tags;
  savedSpot.customMeta = spot.customMeta;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedSpot;
}

@end
