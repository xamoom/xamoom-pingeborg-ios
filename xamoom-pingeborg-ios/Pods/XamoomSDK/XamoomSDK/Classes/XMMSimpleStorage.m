//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMSimpleStorage.h"

@implementation XMMSimpleStorage

- (instancetype)init {
  self = [super init];
  if (self) {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
  }
  return self;
}

- (void)saveTags:(NSArray *)tags {
  [self.userDefaults setObject:tags
                        forKey:@"com.xamoom.ios.offlineTags"];
  [self.userDefaults synchronize];
}

- (NSMutableArray *)readTags {
  NSMutableArray *tags = [[self.userDefaults
                           arrayForKey:@"com.xamoom.ios.offlineTags"] mutableCopy];
  if (tags == nil) {
    tags = [[NSMutableArray alloc] init];
  }
  
  return tags;
}

@end
