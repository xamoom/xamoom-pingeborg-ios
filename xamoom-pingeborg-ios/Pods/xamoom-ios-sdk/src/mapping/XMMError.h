//
//  XMMError.h
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10.07.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface XMMError : NSObject

@property NSString* code;
@property NSString* message;

+ (RKResponseDescriptor*)contentDescriptor;

@end
