//
//  XMMOfflineApiHelper.h
//  XamoomSDK
//
//  Created by Raphael Seher on 11/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

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
