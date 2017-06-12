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

#import "XMMMarker.h"
#import "XMMCDMarker.h"

@implementation XMMMarker

+ (NSString *)resourceName {
  return @"markers";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"markers"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"qr"];
    [__descriptor addProperty:@"nfc"];
    [__descriptor addProperty:@"beaconUUID" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-region-uid"]];
    [__descriptor addProperty:@"beaconMajor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-major"]];
    [__descriptor addProperty:@"beaconMinor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"ibeacon-minor"]];
    [__descriptor addProperty:@"eddyStoneUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"eddystone-url"]];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDMarker *savedMarker = (XMMCDMarker *)object;
    self.ID = savedMarker.jsonID;
    self.qr = savedMarker.qr;
    self.nfc = savedMarker.nfc;
    self.beaconUUID = savedMarker.beaconUUID;
    self.beaconMajor = savedMarker.beaconMajor;
    self.beaconMinor = savedMarker.beaconMinor;
    self.eddyStoneUrl = savedMarker.eddyStoneUrl;
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDMarker insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDMarker class] ID:self.ID];
}

@end
