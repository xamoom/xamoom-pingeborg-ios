//
//  Analytics.m
//  pingeb.org
//
//  Created by Raphael Seher on 16.07.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "Analytics.h"

static Analytics *analytics;
#ifdef DEBUG
static BOOL const kGaDryRun = YES;
#else
static BOOL const kGaDryRun = NO;
#endif
static int const kGaDispatchPeriod = 30;

@interface Analytics ()

@property id<GAITracker> tracker;

@end

@implementation Analytics

+ (Analytics*)sharedObject {
  if(!analytics) {
    analytics = [[Analytics alloc] init];
    [analytics setupAnalytics];
  }
  return analytics;
}

- (void)setupAnalytics {
  NSError *configureError;
  [[GGLContext sharedInstance] configureWithError:&configureError];
  NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
  
  GAI *gai = [GAI sharedInstance];
  gai.trackUncaughtExceptions = YES;
  gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
  
  [gai setDispatchInterval:kGaDispatchPeriod];
  [gai setDryRun:kGaDryRun];
  
  if(kGaDryRun) {
    NSLog(@"Analytics Dry Run enabled");
  }
  
  self.tracker = [[GAI sharedInstance] defaultTracker];
}

- (void)setScreenName:(NSString*)name {
  [self.tracker send:[[[GAIDictionaryBuilder createScreenView] set:name
                                                            forKey:kGAIScreenName] build]];
}

- (void)sendEventWithCategorie:(NSString*)categeorie andAction:(NSString*)action andLabel:(NSString*)label andValue:(NSNumber*)value {
  [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:categeorie
                                                             action:action
                                                              label:label
                                                              value:value] build]];
}

@end
