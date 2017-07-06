//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


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
