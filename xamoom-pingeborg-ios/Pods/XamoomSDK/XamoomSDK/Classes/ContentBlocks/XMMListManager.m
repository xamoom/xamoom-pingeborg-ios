//
//  XMMListManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMListManager.h"
#import "XMMListItem.h"

@interface XMMListManager()

@property NSMutableDictionary *tasks;

@end

@implementation XMMListManager

- (instancetype)initWithApi:(XMMEnduserApi *)api {
  self = [super init];
  
  _api = api;
  _listItems = [[NSMutableDictionary alloc] init];
  _callbacks = [[NSMutableDictionary alloc] init];
  
  _tasks = [[NSMutableDictionary alloc] init];
  
  return self;
}

- (void)downloadContentsWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position callback:(void (^)(NSArray *contents, bool hasMore, int position, NSError *error))completion {
  XMMListItem *item = [self listItemFor:position];
  if (item == nil) {
    item = [[XMMListItem alloc] initWith:tags pageSize:pageSize ascending:ascending];
    [_listItems setObject:item forKey:[NSNumber numberWithInt:position]];
  }
  
  CallbackBlock callback = [self callbackFor:position];
  if (callback == nil) {
    [_callbacks setObject:completion forKey:[NSNumber numberWithInt:position]];
    callback = completion;
  }
  
  XMMContentSortOptions sorting = 0;
  if (ascending) {
    sorting = XMMContentSortOptionsTitle;
  }
  
  if ([_tasks objectForKey:[NSNumber numberWithInt:position]] != nil) {
    return;
  }
  
  NSURLSessionDataTask *task = [_api contentsWithTags:tags pageSize:item.pageSize cursor:item.cursor sort:sorting completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    [_tasks removeObjectForKey:[NSNumber numberWithInt:position]];
    if (error) {
      callback(nil, nil, 0, error);
      return;
    }
    
    [item.contents addObjectsFromArray:contents];
    item.cursor = cursor;
    item.hasMore = hasMore;
    
    callback(contents, item.hasMore, position, nil);
  }];
  
  if (task != nil) {
    [_tasks setObject:task forKey:[NSNumber numberWithInt:position]];
  }
}

- (XMMListItem *)listItemFor:(int)position {
  return [_listItems objectForKey:[NSNumber numberWithInt:position]];
}

- (CallbackBlock)callbackFor:(int)position {
  return [_callbacks objectForKey:[NSNumber numberWithInt:position]];
}

@end
