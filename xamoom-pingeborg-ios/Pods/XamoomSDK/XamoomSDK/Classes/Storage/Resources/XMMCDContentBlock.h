//
//  XMMCDContentBlock.h
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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

@end
