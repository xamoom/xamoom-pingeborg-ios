//
//  NotificationHelper.h
//  pingeb.org
//
//  Created by Raphael Seher on 20/06/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationHelper : NSObject

+ (void)removeAllNotifications;
+ (void)showNotificationWithTitle:(NSString *)title andBody:(NSString *) body;

@end
