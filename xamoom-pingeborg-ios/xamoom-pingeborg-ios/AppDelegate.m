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
#import <XamoomSDK/XMMPushManager.h>

@interface AppDelegate () <XMMPushNotificationDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) XMMPushManager *pushManager;
@property (strong, nonatomic) NavigationCoordinator *navigationCoordinator;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //set UI colors
  [[UINavigationBar appearance] setBarTintColor:[Globals sharedObject].pingeborgYellow];
  [[UITabBar appearance] setTintColor:[Globals sharedObject].pingeborgLinkColor];

  [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];

  //setup API
  [self setupApi];
  [self initBeacons];
  [self setupPushManager];
  
  self.navigationCoordinator = [[NavigationCoordinator alloc] initWithNavigationController: (UINavigationController *) self.window.rootViewController];
  
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

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [self.pushManager handlePushRegistration:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [self.pushManager handlePushRegistrationFailure:error];
  NSLog(@"handlePushRegistrationFailure %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [self.pushManager handlePushReceived:userInfo];
  completionHandler(UIBackgroundFetchResultNoData);
}

- (void)setupApi {
  NSString *file = [[NSBundle mainBundle] pathForResource:@"apikey" ofType:@"txt"];
  NSString *apiKey = [NSString stringWithContentsOfFile:file
                                               encoding:NSUTF8StringEncoding error:NULL];
  
  [XMMEnduserApi sharedInstanceWithKey:apiKey];
}

- (void)initBeacons {
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"de2b94ae-ed98-11e4-3432-78616d6f6f6d"];
  
  self.beaconRegion = [[CLBeaconRegion alloc]
                       initWithProximityUUID:uuid
                       major:52414
                       identifier:@"pingeborg beacons"];
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [self.locationManager requestAlwaysAuthorization];
  }
  
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)setupPushManager {
  self.pushManager = [[XMMPushManager alloc] init];
  self.pushManager.delegate = self;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  [NotificationHelper showNotificationWithTitle:
   NSLocalizedString(@"notification.beacon.title", "")
                                        body:
   NSLocalizedString(@"notification.beacon.body", "")];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region {
  [NotificationHelper removeAllNotifications];
}

// will get called when the user clicks on the notification
- (void)didClickPushNotification:(NSString *)contentId {
  NSLog(@"Did click notification: %@", contentId);
  
  if (contentId != nil) {
    [self.navigationCoordinator openArtistDetailWithContentId:contentId];
  }
}

/**
 *  Allows the MPMoviePlayerViewController to display in landscape-mode, when you only support portrait mode.
 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  if ([[window.rootViewController presentedViewController]
       isKindOfClass:[MPMoviePlayerViewController class]] || [[window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")] || [[window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"AVFullScreenViewController")]) {
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
  }else {
    
    if ([[window.rootViewController presentedViewController]
         isKindOfClass:[UINavigationController class]]) {
      
      // look for it inside UINavigationController
      UINavigationController *nc = (UINavigationController *)[window.rootViewController presentedViewController];
      
      // is at the top?
      if ([nc.topViewController isKindOfClass:[MPMoviePlayerViewController class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
        
        // or it's presented from the top?
      } else if ([[nc.topViewController presentedViewController]
                  isKindOfClass:[MPMoviePlayerViewController class]]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
      }
    }
  }
  
  return UIInterfaceOrientationMaskPortrait;
}
@end
