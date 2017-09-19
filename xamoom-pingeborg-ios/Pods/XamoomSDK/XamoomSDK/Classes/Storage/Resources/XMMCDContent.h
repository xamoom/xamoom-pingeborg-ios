//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMOfflineStorageManager.h"
#import "XMMCDContentBlock.h"
#import "XMMCDSystem.h"
#import "XMMContent.h"

@interface XMMCDContent : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imagePublicUrl;
@property (nonatomic, copy) NSString *contentDescription;
@property (nonatomic, copy) NSString *language;
@property (nonatomic) NSOrderedSet *contentBlocks;
@property (nonatomic) NSNumber *category;
@property (nonatomic) NSArray *tags;
@property (nonatomic) NSDictionary *customMeta;
@property (nonatomic) XMMCDSystem *system;

@end
