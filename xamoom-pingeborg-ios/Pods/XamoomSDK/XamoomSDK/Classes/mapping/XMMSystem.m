//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMSystem.h"
#import "XMMCDSystem.h"
#import "XMMStyle.h"
#import "XMMSystemSettings.h"
#import "XMMMenu.h"

@implementation XMMSystem

+ (NSString *)resourceName {
  return @"systems";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"systems"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"name" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"display-name"]];
    [__descriptor addProperty:@"webClientUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"web-client-url"]];
    [__descriptor addProperty:@"url"];
    [__descriptor hasOne:[XMMSystemSettings class] withName:@"setting"];
    [__descriptor hasOne:[XMMStyle class] withName:@"style"];
    [__descriptor hasOne:[XMMMenu class] withName:@"menu"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDSystem *savedSystem = (XMMCDSystem *)object;
    self.ID = savedSystem.jsonID;
    self.name = savedSystem.name;
    self.url = savedSystem.url;
    self.webClientUrl = savedSystem.webClientUrl;
    if (savedSystem.setting != nil) {
      self.setting = [[XMMSystemSettings alloc] initWithCoreDataObject:savedSystem.setting];
    }
    if (savedSystem.style != nil) {
      self.style = [[XMMStyle alloc] initWithCoreDataObject:savedSystem.style];
    }
    if (savedSystem.menu != nil) {
      self.menu = [[XMMMenu alloc] initWithCoreDataObject:savedSystem.menu];
    }
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDSystem insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDSystem class] ID:self.ID];
}

@end
