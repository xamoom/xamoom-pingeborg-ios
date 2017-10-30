//
//  NSDateFormatter+ISODate.m
//  XamoomSDK
//
//  Created by Raphael Seher on 20/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "NSDateFormatter+ISODate.h"

@implementation NSDateFormatter (ISODate)

static NSDateFormatter *iso8601Formatter;

+ (NSDateFormatter *)ISO8601Formatter {
  if (iso8601Formatter == nil) {
    iso8601Formatter = [[NSDateFormatter alloc] init];
    [iso8601Formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [iso8601Formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
  }

  return iso8601Formatter;
}

@end
