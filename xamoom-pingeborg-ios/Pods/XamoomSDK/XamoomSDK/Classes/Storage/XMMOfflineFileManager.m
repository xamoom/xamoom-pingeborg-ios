//
//  XMMOfflineFileManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 14/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMOfflineFileManager.h"
#import "NSString+MD5.h"

@implementation XMMOfflineFileManager

- (NSURL *)urlForSavedData:(NSString *)urlString {
  return [self filePathForSavedObject:urlString];
}

- (void)saveFileFromUrl:(NSString *)urlString completion:(void (^)(NSString *url, NSData *, NSError *))completion {
  NSURL *filePath = [self filePathForSavedObject:urlString];
  [[XMMOfflineDownloadManager sharedInstance] downloadFileFromUrl:[NSURL URLWithString:urlString]
                                                       completion:^(NSString *url, NSData *data, NSError *error) {
    if (error) {
      if (completion) {
        completion(url, nil, error);
      }
      return;
    }
    
    NSError *savingError;
    [data writeToURL:filePath options:NSDataWritingAtomic error:&savingError];
    
    if (savingError) {
      if (completion) {
        completion(url, nil, savingError);
      }
      
      return;
    }
    
    if (completion) {
      completion(url, data, nil);
    }
  }];
}

- (NSData *)savedDataFromUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSURL *filePath = [self filePathForSavedObject:urlString];
  NSData *data = [NSData dataWithContentsOfURL:filePath options:0 error:error];
  return data;
}

- (UIImage *)savedImageFromUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSData *data = [self savedDataFromUrl:urlString error:error];
  UIImage *image = [UIImage imageWithData:data];
  return image;
}

- (void)deleteFileWithUrl:(NSString *)urlString error:(NSError *__autoreleasing *)error {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager removeItemAtPath:[[self filePathForSavedObject:urlString] path]
                          error:error];
}

#pragma mark - Helper

- (NSURL *)filePathForSavedObject:(NSString *)urlString {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", documentsPath]];
  NSString *fileName = urlString;
  NSURL *fileNameUrl = [NSURL URLWithString:fileName];
  if (fileNameUrl.query != nil) {
    NSString *stringToRemove = [NSString stringWithFormat:@"?%@", [fileNameUrl query]];
    fileName = [fileName stringByReplacingOccurrencesOfString:stringToRemove withString:@""];
  }
  fileName = [fileName MD5String];
  filePath = [filePath URLByAppendingPathComponent:fileName];
  filePath = [filePath URLByAppendingPathExtension:fileNameUrl.pathExtension];
  return filePath;
}

@end
