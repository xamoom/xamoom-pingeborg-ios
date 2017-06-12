//
//  XMMOfflineDownloadManager.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMOfflineDownloadManager : NSObject <NSURLSessionDownloadDelegate>

extern NSString *const kXamoomOfflineUpdateDownloadCount;

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray *currentDownloads;
@property (nonatomic) BOOL startDownloadAutomatically;

+ (instancetype)sharedInstance;

- (void)downloadFileFromUrl:(NSURL *)url
                 completion:(void (^)(NSString *url, NSData *data, NSError *error))completion;

- (void)startDownloads;

@end
