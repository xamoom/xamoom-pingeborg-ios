//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

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
