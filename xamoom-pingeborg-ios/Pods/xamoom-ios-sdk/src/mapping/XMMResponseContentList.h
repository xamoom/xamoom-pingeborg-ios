//
//  XMMResponseContentList.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 02/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

/**
 
 `XMMResponseContentList` is used for mapping the JSON sended by the api.
 */

@interface XMMResponseContentList : NSObject

@property (nonatomic, copy) NSString* cursor;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, copy) NSArray* items;

/// @name Mapping

/**
 Returns a RKResponseDescriptor for `XMMResponseContentList` class.
 
 @return RKResponseDescriptor*
 */
+ (RKResponseDescriptor*)contentDescriptor;

@end
