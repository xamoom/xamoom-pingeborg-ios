//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMPushManager.h"
#import <Pushwoosh/PushNotificationManager.h>

@interface XMMPushManager() <PushNotificationDelegate>

@end

@implementation XMMPushManager

NSString *CONTENT_ID_NAME = @"content_id";

- (instancetype)init {
  if (self == nil) {
    self = [super init];
  }
  
  [self initPush];
  
  return self;
}

- (void)initPush {
  PushNotificationManager *pushManager = [PushNotificationManager pushManager];
  pushManager.delegate = self;
  
  [UNUserNotificationCenter currentNotificationCenter].delegate = [PushNotificationManager pushManager].notificationCenterDelegate;
  
  [[PushNotificationManager pushManager] sendAppOpen];
  [[PushNotificationManager pushManager] registerForPushNotifications];
}

- (void)handlePushRegistration:(NSData *)devToken {
  [[PushNotificationManager pushManager] handlePushRegistration:devToken];
}

- (void)handlePushRegistrationFailure:(NSError *)error {
  [[PushNotificationManager pushManager] handlePushRegistrationFailure:error];
}

- (BOOL)handlePushReceived:(NSDictionary *)userInfo {
  return [[PushNotificationManager pushManager] handlePushReceived:userInfo];
}

- (void)onPushAccepted:(PushNotificationManager *)pushManager
      withNotification:(NSDictionary *)pushNotification onStart:(BOOL)onStart {
  NSString *customDataString = [pushManager getCustomPushData:pushNotification];
  NSString *contentId = [self contentIdFromCustomData:customDataString];
  
  if ([self.delegate respondsToSelector:@selector(didClickPushNotification:)]) {
    [self.delegate didClickPushNotification:contentId];
  }
}

#pragma mark - Helper

- (NSString *)contentIdFromCustomData:(NSString *)customData {
  NSDictionary *jsonData = nil;
  NSString *contentId = nil;
  
  if (customData) {
    jsonData = [NSJSONSerialization
                JSONObjectWithData:[customData dataUsingEncoding:NSUTF8StringEncoding]
                options:NSJSONReadingMutableContainers error:nil];
    
    if (jsonData) {
      contentId = [jsonData objectForKey:CONTENT_ID_NAME];
    }
  }
  
  return contentId;
}

@end
