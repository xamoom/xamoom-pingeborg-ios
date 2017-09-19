//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlocksCache.h"

static XMMContentBlocksCache *sharedInstance;

@interface XMMContentBlocksCache()

@end

@implementation XMMContentBlocksCache

+ (XMMContentBlocksCache *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMContentBlocksCache alloc] init];
    sharedInstance.spotMapCache = [[NSCache alloc] init];
    sharedInstance.contentCache = [[NSCache alloc] init];
  }
  return sharedInstance;
}

- (void)saveSpots:(NSArray *)spotMap key:(NSString *)key {
  if (spotMap == nil || key == nil) {
    return;
  }
  
  [self.spotMapCache setObject:spotMap forKey:key];
}

- (NSArray *)cachedSpotMap:(NSString *)key {
  return [self.spotMapCache objectForKey:key];
}

- (void)saveContent:(XMMContent *)content key:(NSString *)contentID {
  [self.contentCache setObject:content forKey:contentID];
}

- (XMMContent *)cachedContent:(NSString *)key {
  return [self.contentCache objectForKey:key];
}

@end
