//
//  constants.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 17/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "Globals.h"

static Globals *globals;

@implementation Globals

@synthesize aboutPageId;
@synthesize pingeborgLinkColor;
@synthesize pingeborgYellow;

+ (Globals*)sharedObject {
  if(!globals) {
    globals = [[Globals alloc] init];
    globals.pingeborgYellow = [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:0/255.0 alpha:1];
    globals.pingeborgLinkColor = [UIColor colorWithRed:113.0/255.0 green:148.0/255.0 blue:48.0/255.0 alpha:1];
  }
  
  //IF DEV
  if (globals.isDev) {
    globals.aboutPageId = @"f0da3d3d28d3418e9ccc4a6e9b3493c0";
  }
  
  return globals;
}

- (NSInteger)savedSystemId {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults integerForKey:@"pingeborgSystem"];
}

+ (void)setSystemFromInteger:(NSInteger)systemId {
  switch (systemId) {
    case 0: {
      globals.aboutPageId = @"d8be762e9b644fc4bb7aedfa8c0e17b7";
      break;
    }
    case 1: {
      globals.aboutPageId = @"";
      break;
    }
    case 2: {
      globals.aboutPageId = @"";
      break;
    }
    default:
      globals.aboutPageId = @"d8be762e9b644fc4bb7aedfa8c0e17b7";
      break;
  }
}

+ (void)addDiscoveredArtist:(NSString *)contentId {
  NSString *savedArtists;
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults stringForKey:@"savedArtists"]) {
    savedArtists = [userDefaults stringForKey:@"savedArtists"];
    if ([savedArtists containsString:contentId]) {
      return;
    }
    savedArtists = [NSString stringWithFormat:@"%@,%@", savedArtists, contentId];
  }
  else {
    savedArtists = contentId;
  }
  
  [userDefaults setObject:savedArtists forKey:@"savedArtists"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)savedArtits {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ( [userDefaults stringForKey:@"savedArtists"] ) {
    return [userDefaults stringForKey:@"savedArtists"];
  }
  
  return nil;
}

+ (NSArray*)savedArtitsAsArray {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ( [userDefaults stringForKey:@"savedArtists"] ) {
    return [[userDefaults stringForKey:@"savedArtists"] componentsSeparatedByString:@","];
  }
  
  return nil;
}

+ (BOOL)isFirstStart {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults boolForKey:@"isNotFirstStart"]) {
    return NO;
  } else {
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    return YES;
  }
}

+ (BOOL)isFirstTimeGeofencing {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults boolForKey:@"isFirstTimeGeofencing"]) {
    return NO;
  } else {
    [userDefaults setBool:YES forKey:@"isFirstTimeGeofencing"];
    return YES;
  }
}

//IF DEV
- (void)developmentMode {
  globals.isDev = YES;
}

@end
