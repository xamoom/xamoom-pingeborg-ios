//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMCDMarker.h"

@implementation XMMCDMarker

@dynamic jsonID;
@dynamic qr;
@dynamic nfc;
@dynamic beaconUUID;
@dynamic beaconMajor;
@dynamic beaconMinor;
@dynamic eddyStoneUrl;

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
  XMMMarker *marker = (XMMMarker *)entity;
  XMMCDMarker *savedMarker = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:marker.ID];
  if (objects.count > 0) {
    savedMarker = objects.firstObject;
  } else {
    savedMarker = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedMarker.jsonID = marker.ID;
  savedMarker.qr = marker.qr;
  savedMarker.nfc = marker.nfc;
  savedMarker.beaconUUID = marker.beaconUUID;
  savedMarker.beaconMajor = marker.beaconMajor;
  savedMarker.beaconMinor = marker.beaconMinor;
  savedMarker.eddyStoneUrl = marker.eddyStoneUrl;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedMarker;
}
@end
