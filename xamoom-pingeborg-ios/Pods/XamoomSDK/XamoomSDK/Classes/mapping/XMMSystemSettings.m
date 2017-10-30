//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMSystemSettings.h"
#import "XMMCDSystemSettings.h"

@implementation XMMSystemSettings

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (NSString *)resourceName {
  return @"settings";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"settings"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"googlePlayAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-google-play"]];
    [__descriptor addProperty:@"itunesAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-itunes"]];
    [__descriptor addProperty:@"socialSharingEnabled" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-social-sharing-active"]];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDSystemSettings *savedSettings = (XMMCDSystemSettings *)object;
    self.ID = savedSettings.jsonID;
    self.googlePlayAppId = savedSettings.googlePlayId;
    self.itunesAppId = savedSettings.itunesAppId;
    self.socialSharingEnabled = savedSettings.socialSharingEnabled.boolValue;
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDSystemSettings insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDSystemSettings class] ID:self.ID];
}

@end
