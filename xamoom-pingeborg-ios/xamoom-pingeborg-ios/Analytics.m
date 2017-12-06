//
//  Analytics.m
//  pingeb.org
//
//  Created by Raphael Seher on 16.07.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "Analytics.h"

static Analytics *analytics;

@interface Analytics ()

@end

@implementation Analytics

+ (Analytics*)sharedObject {
  if(!analytics) {
    analytics = [[Analytics alloc] init];
  }
  return analytics;
}


- (void)setScreenName:(NSString*)name {
  [FIRAnalytics setScreenName:name screenClass:nil];
}

- (void)sendEventWithCategorie:(NSString*)categeorie andAction:(NSString*)action andLabel:(NSString*)label andValue:(NSNumber*)value {
  [FIRAnalytics logEventWithName:action
                      parameters:@{kFIRParameterValue: label}];
}

@end
