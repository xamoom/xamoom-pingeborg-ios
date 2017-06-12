//
//  XMMOfflineFileManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 14/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMOfflineDownloadManager.h"

@interface XMMOfflineFileManager : NSObject

extern NSString *const kXamoomOfflineSaveFileFromUrlError;

/**
 * Get the url to the localfile from urlString.
 *
 * @param urlString Url string from xamoom cloud.
 * @return NSURL to saved file.
 */
- (NSURL *)urlForSavedData:(NSString *)urlString;

/**
 * Download and save file from url.
 *
 * @param urlString Url string from xamoom cloud.
 * @param completion Block for completion
 */
- (void)saveFileFromUrl:(NSString *)urlString completion:(void(^)(NSString *url, NSData *data, NSError *error))completion;

/**
 * Get data from saved file.
 *
 * @param urlString Url string from xamoom cloud.
 * @param error Error reference.
 * @return NSData from file, nil if error.
 */
- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError **)error;

/**
 * Get image from saved file.
 *
 * @param urlString Url string from xamoom cloud.
 * @param error Error reference.
 * @return UIImage from file, nil if error.
 */
- (UIImage *)savedImageFromUrl:(NSString *)urlString error:(NSError **)error;

/**
 * Delete locally saved file.
 *
 * @param urlString Url string from xamoom cloud.
 * @param error Error reference.
 */
- (void)deleteFileWithUrl:(NSString *)urlString error:(NSError **)error;

@end
