//
//  XMMResponseClosestSpot.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 30/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMResponseStyle.h"

/**
 
 `XMMResponseClosestSpot` is used for mapping the JSON sended by the api.
 */

@interface XMMResponseClosestSpot : NSObject

@property (nonatomic, copy) NSArray* items;
@property (nonatomic, copy) XMMResponseStyle* style;
@property (nonatomic) int radius;
@property (nonatomic) int limit;

/// @name Mapping

/**
 Returns a RKResponseDescriptor for `XMMResponseClosestSpot` class.
 
 @return RKResponseDescriptor*
 */
+ (RKResponseDescriptor*)contentDescriptor;

@end
