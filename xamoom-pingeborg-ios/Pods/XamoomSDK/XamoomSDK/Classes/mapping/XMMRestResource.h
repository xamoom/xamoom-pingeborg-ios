//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMCDResource.h"

/**
 * Base class for every JSONApi resource.
 */
@protocol XMMRestResource <NSObject>

/**
 * JSONApi resource name.
 */
+ (NSString * _Null_unspecified)resourceName;

/**
 * Initialize entity with offline saved entity.
 */
- (instancetype _Null_unspecified)initWithCoreDataObject:(id<XMMCDResource> _Nonnull)object;

/**
 * Initialize entity with offline saved entity and don't add relations.
 */
- (instancetype _Null_unspecified)initWithCoreDataObject:(id<XMMCDResource> _Nonnull)object
                              excludeRelations:(Boolean)excludeRelations;

/**
 * Save offline copy of this entity.
 */
- (id<XMMCDResource> _Nonnull)saveOffline;

/**
 * Delete offline saved copy of this entity.
 */
- (void)deleteOfflineCopy;

@end
