//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import "Globals.h"

static Globals *globals;

@implementation Globals

@synthesize aboutPageId;
@synthesize pingeborgLinkColor;
@synthesize pingeborgYellow;

/**
 *
 */
+ (Globals*)sharedObject {
  if(!globals) {
    globals = [[Globals alloc] init];
    globals.pingeborgYellow = [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:0/255.0 alpha:1];
    globals.pingeborgLinkColor = [UIColor colorWithRed:113.0/255.0 green:148.0/255.0 blue:48.0/255.0 alpha:1];
    globals.aboutPageId = @"d8be762e9b644fc4bb7aedfa8c0e17b7";
    
    //IF DEV
    if (globals.isDev) {
      globals.aboutPageId = @"f0da3d3d28d3418e9ccc4a6e9b3493c0";
    }
  }
  
  return globals;
}

/**
 *
 */
- (NSInteger)savedSystemId {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults integerForKey:@"pingeborgSystem"];
}

/**
 *
 */
- (void)addDiscoveredArtist:(NSString *)contentId {
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

/**
 *
 */
- (NSString *)savedArtits {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ( [userDefaults stringForKey:@"savedArtists"] ) {
    return [userDefaults stringForKey:@"savedArtists"];
  }
  
  return nil;
}

/**
 *
 */
- (NSArray*)savedArtistsAsArray {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ( [userDefaults stringForKey:@"savedArtists"] ) {
    return [[userDefaults stringForKey:@"savedArtists"] componentsSeparatedByString:@","];
  }
  
  return nil;
}

/**
 *
 */
- (BOOL)isFirstStart {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  if ([userDefaults boolForKey:@"isNotFirstStart"]) {
    return NO;
  } else {
    [userDefaults setBool:YES forKey:@"isNotFirstStart"];
    return YES;
  }
}

/**
 *
 */
- (BOOL)isFirstTimeGeofencing {
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
