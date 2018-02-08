//
//  XMMReasons.h
//  XamoomSDK
//
//  Created by Raphael Seher on 30.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#ifndef XMMReasons_h
#define XMMReasons_h

/**
 * Send XMMContentReason to get better statistics on the xamoom dashboard.
 */
typedef NS_ENUM(NSInteger, XMMContentReason) {
  /**
   * Unkown value.
   */
  XMMContentReasonUnknown = 0,
  /**
   * Content is used to display a content link.
   */
  XMMContentReasonLinkedContent = 3,
  /**
   * Content is used to show a notification.
   */
  XMMContentReasonNotificationContentRequest = 4,
  /**
   * Content is loaded after clicking on an notification.
   */
  XMMContentReasonNotificationContentOpenRequest = 5,
  /**
   * Content is loaded and shown because user is near an iBeacon.
   */
  XMMContentReasonBeaconShowContent = 6,
  /**
   * Content is loaded to save offline.
   */
  XMMContentReasonSaveContentOffline = 7,
  /**
   * Content is loaded to show in a menu.
   */
  XMMContentReasonMenuContentRequest = 8
};

#endif /* XMMReasons_h */
