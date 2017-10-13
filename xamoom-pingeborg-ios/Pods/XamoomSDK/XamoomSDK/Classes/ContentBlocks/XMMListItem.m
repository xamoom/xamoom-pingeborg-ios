//
//  XMMListItem.m
//  XamoomSDK
//
//  Created by Raphael Seher on 06/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMListItem.h"

@implementation XMMListItem

- (instancetype)initWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending {
  self = [super init];
  _tags = tags;
  _pageSize = pageSize;
  _cursor = nil;
  _contents = [[NSMutableArray alloc] init];
  _sortAsc = ascending;
  return self;
}

@end
