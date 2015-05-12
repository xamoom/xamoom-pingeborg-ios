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

@synthesize globalSystemId;
@synthesize aboutPageId;
@synthesize pingeborgLinkColor;
@synthesize pingeborgYellow;

+(Globals*)sharedObject {
  if(!globals)
  {
    globals = [[Globals alloc] init];
    globals.pingeborgYellow = [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:0/255.0 alpha:1];
    globals.pingeborgLinkColor = [UIColor colorWithRed:113.0/255.0 green:148.0/255.0 blue:48.0/255.0 alpha:1];
  }
  globals.globalSystemId = [self systemIdFromInteger:[globals savedSystemId]];
  
  //IF DEV
  if (globals.isDev) {
    globals.aboutPageId = @"a5d1ad92a1fa4f6287d37664b39483c2";
    globals.globalSystemId = @"6588702901927936";
  }
  
  return globals;
}

- (NSInteger)savedSystemId {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults integerForKey:@"pingeborgSystem"];
}

+ (NSString*)systemIdFromInteger:(NSInteger)systemId {
  switch (systemId) {
    case 0: {
      globals.aboutPageId = @"";
      return @"Kärnten";
      break;
    }
    case 1: {
      globals.aboutPageId = @"";
      return @"Salzburg";
      break;
    }
    case 2: {
      globals.aboutPageId = @"";
      return @"Vorarlberg";
      break;
    }
    default:
      globals.aboutPageId = @"";
      return @"Kärnten";
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

+ (BOOL)isFirstStart {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults boolForKey:@"isNotFirstStart"]) {
    return NO;
  } else {
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    return YES;
  }
}

//IF DEV
- (void)developmentMode {
  globals.isDev = YES;
}

@end
