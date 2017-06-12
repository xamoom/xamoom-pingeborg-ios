//
//  XMMParamHelper.h
//  XamoomSDK
//
//  Created by Raphael Seher on 29/09/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XMMOptions.h"

@interface XMMParamHelper : NSObject

+ (NSDictionary *)paramsWithLanguage:(NSString *)language;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language locationIdentifier:(NSString *)identifier;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language location:(CLLocation *)location;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language tags:(NSArray *)tags;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language name:(NSString *)name;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language location:(CLLocation *)location radius:(int) radius;

+ (NSDictionary *)addPagingToParams:(NSDictionary *)params pageSize:(int)pageSize cursor:(NSString *)cursor;

+ (NSDictionary *)addContentOptionsToParams:(NSDictionary *)params options:(XMMContentOptions)options;

+ (NSDictionary *)addContentSortOptionsToParams:(NSDictionary *)params options:(XMMContentSortOptions)options;

+ (NSDictionary *)addSpotOptionsToParams:(NSDictionary *)params options:(XMMSpotOptions)options;

+ (NSDictionary *)addSpotSortOptionsToParams:(NSDictionary *)params options:(XMMSpotSortOptions)options;

@end
