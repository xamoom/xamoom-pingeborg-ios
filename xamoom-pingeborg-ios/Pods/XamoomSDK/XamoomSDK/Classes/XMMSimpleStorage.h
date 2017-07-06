//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>

/**
 * Utility for XMMOfflineStorageTagModul to save and read tags.
 */
@interface XMMSimpleStorage : NSObject

@property (strong, nonatomic) NSUserDefaults *userDefaults;

/**
 * Save tags to NSUserDefaults.
 *
 * @param tags NSArray with tags as NSStrings.
 */
- (void)saveTags:(NSArray *)tags;

/**
 * Read tags from NSUserDefaults.
 *
 * @return Saved tags as NSMuteableArray.
 */
- (NSMutableArray *)readTags;

@end
