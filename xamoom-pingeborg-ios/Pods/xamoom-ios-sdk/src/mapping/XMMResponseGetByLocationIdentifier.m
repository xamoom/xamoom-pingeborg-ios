//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMResponseGetByLocationIdentifier.h"

@implementation XMMResponseGetByLocationIdentifier

+ (RKResponseDescriptor*)contentDescriptor {
  // Create mappings
  RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
  
  RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[XMMResponseGetByLocationIdentifier class]];
  [responseMapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                @"system_url":@"systemUrl",
                                                @"system_id":@"systemId",
                                                @"has_content":@"hasContent",
                                                @"has_spot":@"hasSpot",
                                                }];
  RKObjectMapping* responseContentMapping = [XMMResponseContent mapping];
  RKObjectMapping* responseStyleMapping = [XMMResponseStyle mapping];
  RKObjectMapping* responseMenuMapping = [XMMResponseMenuItem mapping];
  
  // Add dynamic matchers
  [dynamicMapping addMatcher:[XMMResponseContentBlockType0 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType1 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType2 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType3 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType4 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType5 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType6 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType7 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType8 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMResponseContentBlockType9 dynamicMappingMatcher]];
  
  // Create relationships
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content"
                                                                                  toKeyPath:@"content"
                                                                                withMapping:responseContentMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"content.content_blocks"
                                                                                  toKeyPath:@"content.contentBlocks"
                                                                                withMapping:dynamicMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"style"
                                                                                  toKeyPath:@"style"
                                                                                withMapping:responseStyleMapping]];
  
  [responseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"menu.items"
                                                                                  toKeyPath:@"menu"
                                                                                withMapping:responseMenuMapping]];
  
  NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
  // Create ResponseDescriptor with objectMapping
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  return contentDescriptor;
}

@end
