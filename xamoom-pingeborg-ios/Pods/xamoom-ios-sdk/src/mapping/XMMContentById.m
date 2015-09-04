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

#import "XMMContentById.h"

@implementation XMMContentById

+ (RKResponseDescriptor*)contentDescriptor {
  
  // Create mappings
  RKDynamicMapping* dynamicMapping = [RKDynamicMapping new];
  
  RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[XMMContentById class]];
  [responseMapping addAttributeMappingsFromDictionary:@{@"system_name":@"systemName",
                                                        @"system_url":@"systemUrl",
                                                        @"system_id":@"systemId",
                                                        }];
  RKObjectMapping* responseContentMapping = [XMMContent mapping];
  RKObjectMapping* responseStyleMapping = [XMMStyle mapping];
  RKObjectMapping* responseMenuMapping = [XMMMenuItem mapping];
  
  // Add dynamic matchers
  [dynamicMapping addMatcher:[XMMContentBlockType0 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType1 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType2 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType3 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType4 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType5 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType6 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType7 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType8 dynamicMappingMatcher]];
  [dynamicMapping addMatcher:[XMMContentBlockType9 dynamicMappingMatcher]];
  
  
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
  
  RKResponseDescriptor *contentDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
  
  return contentDescriptor;
}

@end
