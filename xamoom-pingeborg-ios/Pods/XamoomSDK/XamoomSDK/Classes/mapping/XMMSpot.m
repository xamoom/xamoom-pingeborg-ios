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

@interface XMMSpot()

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
    [__descriptor hasOne:[XMMContent class] withName:@"content"];
    [__descriptor hasOne:[XMMSystem class] withName:@"system"];
    [__descriptor hasOne:[XMMMarker class] withName:@"markers"];
  });
  
  return __descriptor;
}

@end
