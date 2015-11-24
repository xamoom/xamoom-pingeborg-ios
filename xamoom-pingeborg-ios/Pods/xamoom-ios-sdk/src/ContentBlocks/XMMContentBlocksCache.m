//
//  XMMContentBlocksCache.m
//  Pods
//
//  Created by Raphael Seher on 29.10.15.
//
//

#import "XMMContentBlocksCache.h"

static XMMContentBlocksCache *sharedInstance;

@interface XMMContentBlocksCache()

@property (nonatomic, strong) NSCache *spotMapCache;
@property (nonatomic, strong) NSCache *contentCache;

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

- (void)saveSpotMap:(XMMSpotMap *)spotMap key:(NSString *)key {
  [self.spotMapCache setObject:spotMap forKey:key];
}

- (XMMSpotMap *)cachedSpotMap:(NSString *)key {
  return [self.spotMapCache objectForKey:key];
}

- (void)saveContent:(XMMContent *)content key:(NSString *)contentId {
  [self.contentCache setObject:content forKey:contentId];
}

- (XMMContent *)cachedContent:(NSString *)key {
  return [self.contentCache objectForKey:key];
}

@end
