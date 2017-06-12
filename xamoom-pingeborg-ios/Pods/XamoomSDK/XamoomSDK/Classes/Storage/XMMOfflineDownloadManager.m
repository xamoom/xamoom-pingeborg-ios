//
//  XMMOfflineDownloadManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMOfflineDownloadManager.h"

NSString *const kXamoomOfflineUpdateDownloadCount = @"com.xamoom.ios.kXamoomOfflineUpdateDownloadCount";
static XMMOfflineDownloadManager *sharedInstance;

@interface XMMOfflineDownloadManager()

@property (strong, nonatomic) NSMutableDictionary *completionDict;

@end

@implementation XMMOfflineDownloadManager

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[XMMOfflineDownloadManager alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.currentDownloads = [[NSMutableArray alloc] init];
    self.completionDict = [[NSMutableDictionary alloc] init];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    self.startDownloadAutomatically = YES;
  }
  
  return self;
}

- (void)downloadFileFromUrl:(NSURL *)url
                 completion:(void (^)(NSString *url, NSData *data, NSError *error))completion {
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
  
  if (completion) {
    [self.completionDict setObject:completion forKey:url];
  }
  
  if (downloadTask) {
    [self addNewCurrentDownload:downloadTask];
    
    if (self.startDownloadAutomatically) {
      [downloadTask resume];
    }
  }
}

- (void)startDownloads {
  for (NSURLSessionDownloadTask *task in self.currentDownloads) {
    [task resume];
  }
}

- (void)addNewCurrentDownload:(NSURLSessionDownloadTask *)task {
  [self.currentDownloads addObject:task];
  [self sendUpdateDownloadCountNotification];
}

- (void)removeCurrentDownload:(NSURLSessionDownloadTask *)task {
  [self.currentDownloads removeObject:task];
  [self sendUpdateDownloadCountNotification];
}

- (void)sendUpdateDownloadCountNotification {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:kXamoomOfflineUpdateDownloadCount
   object:nil
   userInfo:@{@"count":[NSNumber numberWithUnsignedInteger:self.currentDownloads.count]}];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
  [self removeCurrentDownload:downloadTask];

  void (^completionBlock)(NSString *url, NSData *data, NSError *error) =
  [self.completionDict objectForKey:downloadTask.originalRequest.URL];
  
  if (completionBlock) {
    NSData *data = [NSData dataWithContentsOfURL:location];
    completionBlock(downloadTask.originalRequest.URL.absoluteString, data, nil);
  }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  void (^completionBlock)(NSString *url, NSData *data, NSError *error) = [self.completionDict objectForKey:task.originalRequest.URL];
  if (completionBlock && error) {
    NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)task;
    [self removeCurrentDownload:downloadTask];
    completionBlock(downloadTask.originalRequest.URL.absoluteString, nil, error);
  }
}

@end
