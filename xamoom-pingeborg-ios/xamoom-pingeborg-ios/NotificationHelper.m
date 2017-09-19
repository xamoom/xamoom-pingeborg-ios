//
//  NotificationHelper.m
//  pingeb.org
//
//  Created by Raphael Seher on 20/06/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "NotificationHelper.h"

@implementation NotificationHelper

+ (void)removeAllNotifications {
  UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
  [center removeAllDeliveredNotifications];
  [center removeAllPendingNotificationRequests];
  
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+ (void)showNotificationWithTitle:(NSString *)title andBody:(NSString *)body {
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  [notification setAlertTitle:title];
  [notification setAlertBody:body];
  [notification setFireDate:[[NSDate alloc] init]];
  
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
