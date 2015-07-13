//
//  XMMError.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 10.07.15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMError.h"

@implementation XMMError

+ (RKResponseDescriptor*)contentDescriptor {
  RKObjectMapping *errorMapping = [[RKObjectMapping alloc] initWithClass:[XMMError class]];
  [errorMapping addAttributeMappingsFromArray:@[@"code", @"message"]];
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
  
  RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"error" statusCodes:statusCodes];
  
  return errorDescriptor;
}

@end
