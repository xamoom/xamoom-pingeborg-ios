//
//  XMMListManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"
#import "XMMListItem.h"

@interface XMMListManager : NSObject

typedef void (^CallbackBlock)(NSArray *contents, bool hasMore, int position, NSError *error);

@property XMMEnduserApi *api;
@property NSMutableDictionary *listItems;
@property NSMutableDictionary *callbacks;

- (instancetype)initWithApi:(XMMEnduserApi *)api;

- (void)downloadContentsWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position callback:(void (^)(NSArray *contents, bool hasMore, int position, NSError *error))completion;

- (XMMListItem *)listItemFor:(int)position;

- (CallbackBlock)callbackFor:(int)position;

@end
