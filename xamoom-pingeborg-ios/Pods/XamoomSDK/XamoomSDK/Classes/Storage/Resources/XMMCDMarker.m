//
//  XMMCDMarker.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
