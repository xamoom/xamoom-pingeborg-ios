//
//  XMMSimpleStorage.m
//  XamoomSDK
//
//  Created by Raphael Seher on 24/01/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

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
