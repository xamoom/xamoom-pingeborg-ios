//
//  NSDate+ISODate.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/09/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "NSDate+ISODate.h"

@implementation NSDate (ISODate)

- (NSString *)ISO8601 {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
  return [dateFormatter stringFromDate:self];
}

@end
