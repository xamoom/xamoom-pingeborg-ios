//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XMMOptions.h"

@interface XMMParamHelper : NSObject

+ (NSDictionary *)paramsWithLanguage:(NSString *)language;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language
                  locationIdentifier:(NSString *)identifier;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language
                            location:(CLLocation *)location;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language
                                tags:(NSArray *)tags;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language
                                name:(NSString *)name;

+ (NSDictionary *)paramsWithLanguage:(NSString *)language
                            location:(CLLocation *)location
                              radius:(int) radius;

+ (NSDictionary *)addPagingToParams:(NSDictionary *)params
                           pageSize:(int)pageSize
                             cursor:(NSString *)cursor;

+ (NSDictionary *)addContentOptionsToParams:(NSDictionary *)params
                                    options:(XMMContentOptions)options;

+ (NSDictionary *)addContentSortOptionsToParams:(NSDictionary *)params
                                        options:(XMMContentSortOptions)options;

+ (NSDictionary *)addSpotOptionsToParams:(NSDictionary *)params
                                 options:(XMMSpotOptions)options;

+ (NSDictionary *)addSpotSortOptionsToParams:(NSDictionary *)params
                                     options:(XMMSpotSortOptions)options;

+ (NSDictionary *)addConditionsToParams:(NSDictionary *)params
                             conditions:(NSDictionary *)conditions;

@end
