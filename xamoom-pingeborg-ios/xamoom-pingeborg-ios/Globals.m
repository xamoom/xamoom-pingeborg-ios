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

+(Globals*)sharedObject {
    if(!globals)
    {
        globals = [[Globals alloc] init];
        globals.globalSystemId = [self getSystemIdFromInteger:[globals getSavedId]];
    }
    return globals;
}

- (NSInteger)getSavedId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:@"pingeborgSystem"];
}

+ (NSString*)getSystemIdFromInteger:(NSInteger)systemId {
    switch (systemId) {
        case 0: {
            return @"6588702901927936";
            break;
        }
        case 1: {
            return @"Salzburg";
            break;
        }
        case 2: {
            return @"Vorarlberg";
            break;
        }
        default:
            return @"6588702901927936";
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

@end
