//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMenu.h"
#import "XMMCDMenu.h"
#import "XMMContent.h"
#import "XMMCDContent.h"

@implementation XMMMenu

+ (NSString *)resourceName {
  return @"menus";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"menus"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor hasMany:[XMMContent class] withName:@"items"];

  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDMenu *savedMenu = (XMMCDMenu *)object;
    self.ID = savedMenu.jsonID;
    if (savedMenu.items != nil) {
      NSMutableArray *items = [[NSMutableArray alloc] init];
      for (XMMCDContent *item in savedMenu.items) {
        [items addObject:[[XMMContent alloc] initWithCoreDataObject:item
                                                   excludeRelations:YES]];
      }
      self.items = items;
    }
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDMenu insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDMenu class] ID:self.ID];
}

@end
