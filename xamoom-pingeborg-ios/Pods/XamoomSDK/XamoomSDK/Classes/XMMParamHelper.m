//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMParamHelper.h"

@implementation XMMParamHelper

+ (NSDictionary *)paramsWithLanguage:(NSString *)language {
  NSDictionary *params = @{@"lang":language};
  return params;
}

+ (NSDictionary *)paramsWithLanguage:(NSString *)language locationIdentifier:(NSString *)identifier {
  NSMutableDictionary *params = [[self paramsWithLanguage:language] mutableCopy];
  [params setValue:identifier forKey:@"filter[location-identifier]"];
  
  return params;
}

+ (NSDictionary *)paramsWithLanguage:(NSString *)language location:(CLLocation *)location {
  NSMutableDictionary *params = [[self paramsWithLanguage:language] mutableCopy];
  [params setValue:[@(location.coordinate.latitude) stringValue] forKey:@"filter[lat]"];
  [params setValue:[@(location.coordinate.longitude) stringValue] forKey:@"filter[lon]"];
  
  return params;
}

+ (NSDictionary *)paramsWithLanguage:(NSString *)language tags:(NSArray *)tags {
  NSMutableDictionary *params = [[self paramsWithLanguage:language] mutableCopy];
  NSString *tagsAsParameter = [NSString stringWithFormat:@"[\"%@\"]", [tags componentsJoinedByString:@"\",\""]];
  [params setValue:tagsAsParameter forKey:@"filter[tags]"];
  return params;
}

+ (NSDictionary *)paramsWithLanguage:(NSString *)language name:(NSString *)name {
  NSMutableDictionary *params = [[self paramsWithLanguage:language] mutableCopy];
  [params setValue:name forKey:@"filter[name]"];
  return params;
}

+ (NSDictionary *)paramsWithLanguage:(NSString *)language location:(CLLocation *)location radius:(int) radius {
  NSMutableDictionary *params = [[self paramsWithLanguage:language] mutableCopy];
  [params setValue:[@(location.coordinate.latitude) stringValue] forKey:@"filter[lat]"];
  [params setValue:[@(location.coordinate.longitude) stringValue] forKey:@"filter[lon]"];
  [params setValue:[@(radius) stringValue] forKey:@"filter[radius]"];

  return params;
}

+ (NSDictionary *)addPagingToParams:(NSDictionary *)params pageSize:(int)pageSize cursor:(NSString *)cursor {
  NSMutableDictionary *mutableParams = [params mutableCopy];
  
  if (pageSize != 0) {
    [mutableParams setValue:[@(pageSize) stringValue] forKey:@"page[size]"];
  }
  
  if (cursor != nil && ![cursor isEqualToString:@""]) {
    [mutableParams setObject:cursor forKey:@"page[cursor]"];
  }
  
  return mutableParams;
}

+ (NSDictionary *)addContentOptionsToParams:(NSDictionary *)params options:(XMMContentOptions)options {
  NSMutableDictionary *mutableParams = [params mutableCopy];
 
  if (options != XMMContentOptionsNone) {
    NSDictionary *optionsDict = [self contentOptionsToDictionary:options];
    [mutableParams addEntriesFromDictionary:optionsDict];
  }
  
  return mutableParams;
}

+ (NSDictionary *)addContentSortOptionsToParams:(NSDictionary *)params options:(XMMContentSortOptions)options {
  NSMutableDictionary *mutableParams = [params mutableCopy];
  
  if (options != XMMContentSortOptionsNone) {
    NSArray *sortParameter = [self contentSortOptionsToArray:options];
    [mutableParams setObject:[sortParameter componentsJoinedByString:@","] forKey:@"sort"];
  }
  
  return mutableParams;
}


+ (NSDictionary *)addSpotOptionsToParams:(NSDictionary *)params options:(XMMSpotOptions)options {
  NSMutableDictionary *mutableParams = [params mutableCopy];
  
  if (options != XMMSpotOptionsNone) {
    NSDictionary *optionsDict = [self spotOptionsToDictionary:options];
    [mutableParams addEntriesFromDictionary:optionsDict];
  }
  
  return mutableParams;
}

+ (NSDictionary *)addSpotSortOptionsToParams:(NSDictionary *)params options:(XMMSpotSortOptions)options {
  NSMutableDictionary *mutableParams = [params mutableCopy];
  
  if (options != XMMSpotSortOptionsNone) {
    NSArray *sortParameter = [self spotSortOptionsToArray:options];
    [mutableParams setObject:[sortParameter componentsJoinedByString:@","] forKey:@"sort"];
  }
  
  return mutableParams;
}

// Helper

+ (NSDictionary *)contentOptionsToDictionary:(XMMContentOptions)options {
  NSMutableDictionary *optionsDict = [[NSMutableDictionary alloc] init];
  
  if (options & XMMContentOptionsPreview) {
    [optionsDict setObject:@"true" forKey:@"preview"];
  }
  if (options & XMMContentOptionsPrivate) {
    [optionsDict setObject:@"true" forKey:@"public-only"];
  }
  
  return optionsDict;
}

+ (NSArray *)contentSortOptionsToArray:(XMMContentSortOptions)sortOptions {
  NSMutableArray *sortParameters = [[NSMutableArray alloc] init];
  
  if (sortOptions & XMMContentSortOptionsTitle) {
    [sortParameters addObject:@"name"];
  }
  
  if (sortOptions & XMMContentSortOptionsNameDesc) {
    [sortParameters addObject:@"-name"];
  }
  
  return sortParameters;
}

+ (NSMutableDictionary *)spotOptionsToDictionary:(XMMSpotOptions)options {
  NSMutableDictionary *optionsDict = [[NSMutableDictionary alloc] init];
  
  if (options & XMMSpotOptionsIncludeMarker) {
    [optionsDict setObject:@"true" forKey:@"include_markers"];
  }
  
  if (options & XMMSpotOptionsIncludeContent) {
    [optionsDict setObject:@"true" forKey:@"include_content"];
  }
  
  if (options & XMMSpotOptionsWithLocation) {
    [optionsDict setObject:@"true" forKey:@"filter[has-location]"];
  }
  
  return optionsDict;
}


+ (NSArray *)spotSortOptionsToArray:(XMMSpotSortOptions)sortOptions {
  NSMutableArray *sortParameters = [[NSMutableArray alloc] init];
  
  if (sortOptions & XMMSpotSortOptionsName) {
    [sortParameters addObject:@"name"];
  }
  
  if (sortOptions & XMMSpotSortOptionsNameDesc) {
    [sortParameters addObject:@"-name"];
  }
  
  if (sortOptions & XMMSpotSortOptionsDistance) {
    [sortParameters addObject:@"distance"];
  }
  
  if (sortOptions & XMMSpotSortOptionsDistanceDesc) {
    [sortParameters addObject:@"-distance"];
  }
  
  return sortParameters;
}

+ (NSDictionary *)addConditionsToParams:(NSDictionary *)params
                             conditions:(NSDictionary *)conditions {
  NSMutableDictionary *newParams = [[NSMutableDictionary alloc]
                                    initWithDictionary:params];
  
  for (NSString *key in conditions) {
    NSString *value = [self conditionToString: [conditions objectForKey:key]];
    if (value != nil) {
      NSString *keyString = [NSString stringWithFormat:@"condition[%@]", key];
      [newParams setObject:value forKey:keyString];
    }
  }
  
  return newParams;
}

+ (NSString *)conditionToString:(id)condition {
  if ([condition isKindOfClass:[NSString class]]) {
    return condition;
  }
  
  if ([condition isKindOfClass:[NSNumber class]]) {
    NSNumber *number = (NSNumber *)condition;
    return number.stringValue;
  }
  
  if ([condition isKindOfClass:[NSDate class]]) {
    NSDate *date = (NSDate *)condition;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter stringFromDate:date];
  }
  
  return nil;
}

@end
