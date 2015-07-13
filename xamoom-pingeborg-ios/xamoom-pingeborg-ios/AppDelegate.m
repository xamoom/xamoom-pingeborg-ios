//
//  AppDelegate.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 05/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "XMMEnduserApi.h"
#import "Globals.h"
#import "GAI.h"

NSString* apiKey = @"3441ff29-7113-418b-a5b5-5de2e50de21b";
NSString* devApiKey = @"4552f99b-2b34-4f18-81a1-0911e25351d7";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  //set UI colors
  [[UINavigationBar appearance] setBarTintColor:[Globals sharedObject].pingeborgYellow];
  [[UITabBar appearance] setTintColor:[Globals sharedObject].pingeborgLinkColor];
  
  //IF DEV
  [[Globals sharedObject] developmentMode];
  [[XMMEnduserApi sharedInstance] setApiKey:devApiKey];
  
  //Google Analytics
  
  // Optional: automatically send uncaught exceptions to Google Analytics.
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  
  // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
  [GAI sharedInstance].dispatchInterval = 20;
  
  // Optional: set Logger to VERBOSE for debug information.
  [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
  
  // Initialize tracker. Replace with your tracking ID.
  [[GAI sharedInstance] trackerWithTrackingId:@"UA-57427460-2"];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
