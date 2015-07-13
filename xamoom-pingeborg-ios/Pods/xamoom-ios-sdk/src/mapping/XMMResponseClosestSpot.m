//
//  XMMResponseClosestSpot.m
//  xamoom-ios-sdk-test
//
//  Created by Raphael Seher on 30/04/15.
//  Copyright (c) 2015 Raphael Seher. All rights reserved.
//

#import "XMMResponseClosestSpot.h"

@implementation XMMResponseClosestSpot

+ (RKResponseDescriptor*)contentDescriptor {
  // Create mappings
  RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[XMMResponseClosestSpot class]];
  [responseMapping addAttributeMappingsFromDictionary:@{@"radius":@"radius",
                                                @"limit":@"limit",
                                                }];

  RKObjectMapping* responseItemMapping = [XMMResponseGetSpotMapItem mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"items"
                                                                                  toKeyPath:@"items"
                                                                                withMapping:responseItemMapping]];
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  return contentDescriptor;
}

@end
