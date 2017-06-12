//
//  XMMOfflinePagedResult.h
//  XamoomSDK
//
//  Created by Raphael Seher on 11/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMMOfflinePagedResult : NSObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *cursor;
@property (nonatomic, assign) bool hasMore;

@end
