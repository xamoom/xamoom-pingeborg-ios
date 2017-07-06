//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


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
