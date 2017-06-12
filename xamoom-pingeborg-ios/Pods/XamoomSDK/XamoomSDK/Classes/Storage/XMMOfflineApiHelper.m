//
//  XMMOfflineApiHelper.m
//  XamoomSDK
//
//  Created by Raphael Seher on 11/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "XMMOfflineApiHelper.h"
#import "XMMCDContent.h"
#import "XMMCDSpot.h"
#import "XMMOfflinePagedResult.h"

@implementation XMMOfflineApiHelper

- (NSArray *)spotsInsideGeofence:(NSArray *)spots location:(CLLocation *)location radius:(int)radius {
  NSMutableArray *spotsInsideRadius = [[NSMutableArray alloc] init];
  
  for (XMMCDSpot *spot in spots) {
    double latitude = [[spot.locationDictionary objectForKey:@"lat"] doubleValue];
    double longitude = [[spot.locationDictionary objectForKey:@"lon"] doubleValue];
    CLLocation *spotLocation =
    [[CLLocation alloc] initWithLatitude:latitude
                               longitude:longitude];
    
    if ([location distanceFromLocation:spotLocation] <= radius) {
      [spotsInsideRadius addObject:spot];
    }
  }
  
  return spotsInsideRadius;
}

- (NSArray *)entitiesWithTags:(NSArray *)entities tags:(NSArray *)tags {
  NSMutableArray *entitiesWithTags = [[NSMutableArray alloc] init];
  for (id savedEntity in entities) {
    for (NSString *tag in tags) {
      if ([savedEntity respondsToSelector:@selector(tags)]) {
        if ([[savedEntity valueForKey:@"tags"] containsObject:tag] &&
            ![entitiesWithTags containsObject:savedEntity]) {
          [entitiesWithTags addObject:savedEntity];
        }
      }
    }
  }
  
  return entitiesWithTags;
}

- (NSArray *)sortArrayByPropertyName:(NSArray *)array propertyName:(NSString *)propertyName ascending:(BOOL)ascending {
  NSSortDescriptor *sortDescriptor;
  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName
                                               ascending:ascending];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  return [array sortedArrayUsingDescriptors:sortDescriptors];
}

- (XMMOfflinePagedResult *)pageResults:(NSArray *)results
                              pageSize:(int)pageSize
                                cursor:(NSString *)cursor {
  XMMOfflinePagedResult *pagedResult = [[XMMOfflinePagedResult alloc] init];
  
  if (results == nil) {
    pagedResult.items = [[NSArray alloc] init];
    pagedResult.hasMore = NO;
    return pagedResult;
  }
  
  if (results.count > pageSize) {
    if (cursor == nil) {
      pagedResult.items = [results subarrayWithRange:NSMakeRange(0, pageSize)];
      pagedResult.hasMore = YES;
    } else {
      int startIndex = [[self numberFromString:cursor] intValue] * pageSize;
      int size = pageSize;
      if (size + startIndex > results.count) {
        size = (unsigned) results.count - startIndex;
      }
      if (results.count > startIndex+pageSize) {
        pagedResult.hasMore = YES;
      }
      pagedResult.items = [results subarrayWithRange:NSMakeRange(startIndex, size)];
    }
  } else if(results.count <= pageSize) {
    pagedResult.items = results;
  }
  
  if (cursor == nil) {
    pagedResult.cursor = @"1";
  } else {
    pagedResult.cursor = [NSString stringWithFormat:@"%d",
                          [[self numberFromString:cursor] intValue] + 1];
  }
  
  return pagedResult;
}

# pragma mark - Helper

- (NSNumber *)numberFromString:(NSString *)string {
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  return [f numberFromString:string];
}

@end
