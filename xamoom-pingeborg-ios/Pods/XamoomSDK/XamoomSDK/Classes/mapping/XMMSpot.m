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

#import "XMMSpot.h"
#import "XMMCDSpot.h"

@interface XMMSpot()

/**
 * Custom meta as list of key value objects.
 */
@property (nonatomic) NSArray *customMetaArray;

@end

@implementation XMMSpot

- (instancetype)init {
  self = [super init];
  self.locationDictionary = [[NSMutableDictionary alloc] init];
  return self;
}

- (double)latitude {
  NSNumber *latitude = (NSNumber *)[self.locationDictionary objectForKey:@"lat"];
  return latitude.doubleValue;
}

- (void)setLatitude:(double)latitude {
  [self.locationDictionary setObject:[NSNumber numberWithDouble:latitude] forKey:@"lat"];
}

- (double)longitude {
  NSNumber *longitude = (NSNumber *)[self.locationDictionary objectForKey:@"lon"];
  return longitude.doubleValue;
}

- (void)setLongitude:(double)longitude {
  [self.locationDictionary setObject:[NSNumber numberWithDouble:longitude] forKey:@"lon"];
}

+ (NSString *)resourceName {
  return @"spots";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"spots"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"name" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"name"]];
    [__descriptor addProperty:@"spotDescription" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"description"]];
    [__descriptor addProperty:@"locationDictionary" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"location"]];
    [__descriptor addProperty:@"image" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"image"]];
    [__descriptor addProperty:@"category"];
    [__descriptor addProperty:@"tags"];
    [__descriptor addProperty:@"customMetaArray" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"custom-meta"]];
    [__descriptor hasOne:[XMMContent class] withName:@"content"];
    [__descriptor hasOne:[XMMSystem class] withName:@"system"];
    [__descriptor hasOne:[XMMMarker class] withName:@"markers"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDSpot *savedSpot = (XMMCDSpot *)object;
    self.ID = savedSpot.jsonID;
    self.name = savedSpot.name;
    self.spotDescription = savedSpot.spotDescription;
    self.locationDictionary = savedSpot.locationDictionary;
    self.image = savedSpot.image;
    self.category = [savedSpot.category intValue];
    self.tags = savedSpot.tags;
    self.customMeta = savedSpot.customMeta;
    
    if (savedSpot.markers != nil) {
      NSMutableArray *markers = [[NSMutableArray alloc] init];
      for (XMMCDMarker *savedMarker in savedSpot.markers) {
        [markers addObject:[[XMMMarker alloc] initWithCoreDataObject:savedMarker]];
      }
      self.markers = markers;
    }
    if (savedSpot.content != nil) {
      self.content = [[XMMContent alloc] initWithCoreDataObject:(id<XMMCDResource>)savedSpot.content];
    }
    if (savedSpot.system != nil) {
      self.system = [[XMMSystem alloc] initWithCoreDataObject:savedSpot.system];
    }
  }
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDSpot insertNewObjectFrom:self];
}

- (id<XMMCDResource>)saveOffline:(void (^)(NSString *url, NSData *, NSError *))downloadCompletion {
  return [XMMCDSpot insertNewObjectFrom:self
                            fileManager:[[XMMOfflineFileManager alloc] init]
                             completion:downloadCompletion];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDSpot class] ID:self.ID];
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
