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

#import "AppDelegate.h"
#import "XMMEnduserApi.h"
#import "Globals.h"
#import "GAI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  //set UI colors
  [[UINavigationBar appearance] setBarTintColor:[Globals sharedObject].pingeborgYellow];
  [[UITabBar appearance] setTintColor:[Globals sharedObject].pingeborgLinkColor];
    
  //IF DEV
  //[[Globals sharedObject] developmentMode];
  
  NSString *file = [[NSBundle mainBundle] pathForResource:@"apikey" ofType:@"txt"];
  NSString *apiKey = [NSString stringWithContentsOfFile:file
                                            encoding:NSUTF8StringEncoding error:NULL];
  
  [[XMMEnduserApi sharedInstance] setApiKey:apiKey];
  
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
