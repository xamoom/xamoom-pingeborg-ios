//
//  XMMResponseContentList.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 02/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseContentList.h"

@implementation XMMResponseContentList

+ (RKResponseDescriptor*)contentDescriptor {
  RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[XMMResponseContentList class]];
  [responseMapping addAttributeMappingsFromDictionary:@{@"cursor":@"cursor",
                                                        @"more":@"hasMore",
                                                        }];
  RKObjectMapping* responseItemMapping = [XMMResponseContent mapping];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:statusCodes];

  
  return contentDescriptor;
}

@end
