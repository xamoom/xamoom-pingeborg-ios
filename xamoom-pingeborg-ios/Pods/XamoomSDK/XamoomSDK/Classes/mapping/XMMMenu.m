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

#import "XMMMenu.h"
#import "XMMCDMenu.h"
#import "XMMContent.h"
#import "XMMCDContent.h"

@implementation XMMMenu

+ (NSString *)resourceName {
  return @"menus";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"menus"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor hasMany:[XMMContent class] withName:@"items"];

  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDMenu *savedMenu = (XMMCDMenu *)object;
    self.ID = savedMenu.jsonID;
    if (savedMenu.items != nil) {
      NSMutableArray *items = [[NSMutableArray alloc] init];
      for (XMMCDContent *item in savedMenu.items) {
        [items addObject:[[XMMContent alloc] initWithCoreDataObject:item
                                                   excludeRelations:YES]];
      }
      self.items = items;
    }
  }
  
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDMenu insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDMenu class] ID:self.ID];
}

@end
