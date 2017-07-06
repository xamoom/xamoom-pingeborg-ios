//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>

@class XMMOfflinePagedResult;

@interface XMMOfflineApiHelper : NSObject

- (NSArray *)spotsInsideGeofence:(NSArray *)spots location:(CLLocation *)location radius:(int)radius;

- (NSArray *)entitiesWithTags:(NSArray *)contents tags:(NSArray *)tags;

- (NSArray *)sortArrayByPropertyName:(NSArray *)array propertyName:(NSString *)propertyName ascending:(BOOL)ascending;

- (XMMOfflinePagedResult *)pageResults:(NSArray *)results
                                  pageSize:(int)pageSize
                                cursor:(NSString *)cursor;
@end
