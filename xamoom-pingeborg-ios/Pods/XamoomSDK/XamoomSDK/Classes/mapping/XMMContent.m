//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContent.h"
#import "XMMCDContent.h"
#import "NSDateFormatter+ISODate.h"

@interface XMMContent()

/**
 * Custom meta as list of key value objects.
 */
@property (nonatomic) NSArray *customMetaArray;

@end

@implementation XMMContent

+ (NSString *)resourceName {
  return @"contents";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"contents"];
    
    [__descriptor setIdProperty:@"ID"];
    [__descriptor addProperty:@"title" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"display-name"]];
    [__descriptor addProperty:@"contentDescription" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"description"]];
    [__descriptor addProperty:@"imagePublicUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"cover-image-url"]];
    [__descriptor addProperty:@"language"];
    [__descriptor addProperty:@"category"];
    [__descriptor addProperty:@"tags"];
    [__descriptor addProperty:@"customMetaArray" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"custom-meta"]];
    [__descriptor addProperty:@"sharingUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"social-sharing-url"]];
    [__descriptor addProperty:@"toDate" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"meta-datetime-to" withFormat:[NSDateFormatter ISO8601Formatter]]];
    [__descriptor addProperty:@"fromDate" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"meta-datetime-from" withFormat:[NSDateFormatter ISO8601Formatter]]];
    [__descriptor hasOne:[XMMSystem class] withName:@"system"];
    [__descriptor hasOne:[XMMSpot class] withName:@"spot"];
    [__descriptor hasOne:[XMMSpot class] withName:@"relatedSpot" withJsonName:@"related-spot"];
    [__descriptor hasMany:[XMMContentBlock class] withName:@"contentBlocks" withJsonName:@"blocks"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object
                              excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDContent *savedContent = (XMMCDContent *)object;
    self.ID = savedContent.jsonID;
    self.title = savedContent.title;
    self.imagePublicUrl = savedContent.imagePublicUrl;
    self.contentDescription = savedContent.contentDescription;
    self.language = savedContent.language;
    self.category = [savedContent.category intValue];
    self.tags = savedContent.tags;
    self.customMeta = savedContent.customMeta;
    self.sharingUrl = savedContent.sharingUrl;
    if (savedContent.relatedSpot != nil) {
      self.relatedSpot = [[XMMSpot alloc] initWithCoreDataObject:savedContent.relatedSpot];
    }
    self.toDate = savedContent.toDate;
    self.fromDate = savedContent.fromDate;
    
    if (savedContent.contentBlocks != nil) {
      NSMutableArray *blocks = [[NSMutableArray alloc] init];
      for (XMMCDContentBlock *block in savedContent.contentBlocks) {
        [blocks addObject:[[XMMContentBlock alloc] initWithCoreDataObject:block]];
      }
      self.contentBlocks = blocks;
    }
    
    if (savedContent.system != nil && !excludeRelations) {
      self.system = [[XMMSystem alloc] initWithCoreDataObject:savedContent.system];
    }
    
  }
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDContent insertNewObjectFrom:self];
}

- (id<XMMCDResource>)saveOffline:(void (^)(NSString *url, NSData *, NSError *))downloadCompletion {
  return [XMMCDContent insertNewObjectFrom:self
                               fileManager:[[XMMOfflineFileManager alloc] init]
                                completion:downloadCompletion];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDContent class] ID:self.ID];
}

- (NSDictionary *)customMeta {
  NSMutableDictionary *customMetaDict = [[NSMutableDictionary alloc] init];
  
  for (NSDictionary *dict in self.customMetaArray) {
    [customMetaDict setObject:[dict objectForKey:@"value"] forKey:[dict objectForKey:@"key"]];
  }
  
  return customMetaDict;
}

- (void)setCustomMeta:(NSDictionary *)customMeta {
  NSMutableArray *customMetaArray = [[NSMutableArray alloc] init];
  
  for (NSString *key in customMeta) {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:key forKey:@"key"];
    [dict setObject:[customMeta objectForKey:key] forKey:@"value"];
    [customMetaArray addObject: dict];
  }
 
  self.customMetaArray = customMetaArray;
}

@end
