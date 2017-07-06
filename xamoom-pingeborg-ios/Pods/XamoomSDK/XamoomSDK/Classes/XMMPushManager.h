//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>

@protocol XMMPushNotificationDelegate <NSObject>

- (void)didClickPushNotification:(NSString *)contentId;

@end

/**
 * XMMPushManager enables you to receive Push Notifications from the xamoom
 * backend. 
 *
 * Create an instance and set the XMMPushNotificationDelegate.
 *
 * For setup instructions please visit our github page.
 * (https://github.com/xamoom/xamoom-ios-sdk)
 */
@interface XMMPushManager : NSObject

@property (weak) id<XMMPushNotificationDelegate> delegate;

/**
 * Initialize XMMPushManager and setup push notifications.
 *
 * @return PushManager instance
 */
- (instancetype)init;

/**
 * Handle push registration success.
 * Wraps [pushNotificationManager handlePushRegistration:].
 *
 * @param devToken Device token from application callback.
 */
- (void)handlePushRegistration:(NSData *)devToken;

/**
 * Handle push registration failure.
 * Wraps [pushNotificationManager handlePushRegistrationFailure:].
 *
 * @param error Registrations error.
 */
- (void)handlePushRegistrationFailure:(NSError *)error;

/**
 * Handle push received.
 * Wraps [pushNotificationManager handlePushReceived].
 *
 * @param userInfo Push notifications userData.
 */
- (BOOL)handlePushReceived:(NSDictionary *)userInfo;

@end
