//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMContent.h"

@interface XMMContentBlocksCache : NSObject

@property (nonatomic, strong) NSCache *spotMapCache;
@property (nonatomic, strong) NSCache *contentCache;

+ (XMMContentBlocksCache *)sharedInstance;

- (void)saveSpots:(NSArray *)spotMap key:(NSString *)key;
- (NSArray *)cachedSpotMap:(NSString *)key;
- (void)saveContent:(XMMContent *)content key:(NSString *)contentID;
- (XMMContent *)cachedContent:(NSString *)key;

@end
