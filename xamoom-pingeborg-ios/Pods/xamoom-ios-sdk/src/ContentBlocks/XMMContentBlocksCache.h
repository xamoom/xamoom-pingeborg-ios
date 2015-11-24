//
//  XMMContentBlocksCache.h
//  Pods
//
//  Created by Raphael Seher on 29.10.15.
//
//

#import <Foundation/Foundation.h>
#import "XMMSpotMap.h"

@class XMMSpotMap;

@interface XMMContentBlocksCache : NSObject

+ (XMMContentBlocksCache *)sharedInstance;

- (void)saveSpotMap:(XMMSpotMap *)spotMap key:(NSString *)key;
- (XMMSpotMap *)cachedSpotMap:(NSString *)key;
- (void)saveContent:(XMMContent *)content key:(NSString *)contentId;
- (XMMContent *)cachedContent:(NSString *)key;

@end
