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

#import "XMMSystemSettings.h"
#import "XMMCDSystemSettings.h"

@implementation XMMSystemSettings

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (NSString *)resourceName {
  return @"settings";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"settings"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"googlePlayAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-google-play"]];
    [__descriptor addProperty:@"itunesAppId" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"app-id-itunes"]];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDSystemSettings *savedSettings = (XMMCDSystemSettings *)object;
    self.ID = savedSettings.jsonID;
    self.googlePlayAppId = savedSettings.googlePlayId;
    self.itunesAppId = savedSettings.itunesAppId;
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDSystemSettings insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDSystemSettings class] ID:self.ID];
}

@end
