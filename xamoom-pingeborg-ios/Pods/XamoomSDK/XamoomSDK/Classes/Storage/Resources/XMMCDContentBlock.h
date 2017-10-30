//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <CoreData/CoreData.h>
#import "XMMCDResource.h"
#import "XMMOfflineStorageManager.h"
#import "XMMContentBlock.h"

@interface XMMCDContentBlock : NSManagedObject <XMMCDResource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSNumber *publicStatus;
@property (nonatomic) NSNumber *blockType;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *artists;
@property (nonatomic) NSString *fileID;
@property (nonatomic) NSString *soundcloudUrl;
@property (nonatomic) NSNumber *linkType;
@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSString *contentID;
@property (nonatomic) NSNumber *downloadType;
@property (nonatomic) NSArray *spotMapTags;
@property (nonatomic) NSNumber *scaleX;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSNumber *showContent;
@property (nonatomic) NSString *altText;
@property (nonatomic) NSString *copyright;
@property (nonatomic) NSArray *contentListTags;
@property (nonatomic) NSNumber *contentListPageSize;
@property (nonatomic) NSNumber *contentListSortAsc;

@end
