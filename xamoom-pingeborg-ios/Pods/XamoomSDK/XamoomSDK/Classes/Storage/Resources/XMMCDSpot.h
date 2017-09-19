//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMOfflineStorageManager.h"
#import "XMMCDResource.h"
#import "XMMSpot.h"
#import "XMMCDMarker.h"
#import "XMMCDSystem.h"

@class XMMCDContent;

@interface XMMCDSpot : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *spotDescription;
@property (nonatomic, copy) NSString *image;
@property (nonatomic) NSNumber *category;
@property (nonatomic) NSMutableDictionary *locationDictionary;
@property (nonatomic) NSArray *tags;
@property (nonatomic) XMMCDContent *content;
@property (nonatomic) NSSet *markers;
@property (nonatomic) NSDictionary *customMeta;
@property (nonatomic) XMMCDSystem *system;

@end
