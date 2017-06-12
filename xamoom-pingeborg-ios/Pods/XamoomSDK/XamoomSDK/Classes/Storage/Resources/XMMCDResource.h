//
//  XMMCDResource.h
//  XamoomSDK
//
//  Created by Raphael Seher on 03/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMOfflineStorageManager.h"
#import "XMMOfflineFileManager.h"

@protocol XMMCDResource <NSObject>

@property (nonatomic, strong) NSString* jsonID;

+ (NSString *)coreDataEntityName;

+ (instancetype)insertNewObjectFrom:(id)entity;

+ (instancetype)insertNewObjectFrom:(id)entity
                    fileManager:(XMMOfflineFileManager *)fileManager;

+ (instancetype)insertNewObjectFrom:(id)entity
                        fileManager:(XMMOfflineFileManager *)fileManager
                         completion:(void(^)(NSString *url, NSData *data, NSError *error))completion;

@end
