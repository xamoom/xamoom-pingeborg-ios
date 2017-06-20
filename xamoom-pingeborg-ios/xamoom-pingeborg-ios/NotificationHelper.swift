//
//  NotificationHelper.swift
//  pingeb.org
//
//  Created by Raphael Seher on 20/06/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHelper {
  
  static func removeAllNotifications() {
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      center.removeAllPendingNotificationRequests()
      center.removeAllDeliveredNotifications()
    } else {
      UIApplication.shared.cancelAllLocalNotifications()
    }
    UIApplication.shared.applicationIconBadgeNumber = 0
    UIApplication.shared.cancelAllLocalNotifications()
  }
  
  static func showNotification(title: String, body: String) {
    let notification = UILocalNotification()
    notification.alertTitle = title
    notification.alertBody = body
    notification.fireDate = Date()
    
    UIApplication.shared.scheduleLocalNotification(notification)
  }
}
