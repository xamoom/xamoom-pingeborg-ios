//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMarker.h"
#import "XMMCDMarker.h"

@implementation XMMMarker

+ (NSString *)resourceName {
  return @"markers";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"markers"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"qr"];
    [__descriptor addProperty:@"nfc"];
    [__descriptor addProperty:@"beaconUUID" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-region-uid"]];
    [__descriptor addProperty:@"beaconMajor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-major"]];
    [__descriptor addProperty:@"beaconMinor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-minor"]];
    [__descriptor addProperty:@"eddyStoneUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"eddystone-url"]];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDMarker *savedMarker = (XMMCDMarker *)object;
    self.ID = savedMarker.jsonID;
    self.qr = savedMarker.qr;
    self.nfc = savedMarker.nfc;
    self.beaconUUID = savedMarker.beaconUUID;
    self.beaconMajor = savedMarker.beaconMajor;
    self.beaconMinor = savedMarker.beaconMinor;
    self.eddyStoneUrl = savedMarker.eddyStoneUrl;
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDMarker insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDMarker class] ID:self.ID];
}

@end
