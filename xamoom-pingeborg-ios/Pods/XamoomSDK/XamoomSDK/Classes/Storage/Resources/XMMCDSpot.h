//
//  XMMCDSpot.h
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
