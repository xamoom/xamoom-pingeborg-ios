//
//  XMMCDContentBlock.m
//  XamoomSDK
//
//  Created by Raphael Seher on 05/10/2016.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "XMMCDContentBlock.h"
#import "XMMOfflineFileManager.h"

@implementation XMMCDContentBlock

@dynamic jsonID;
@dynamic title;
@dynamic publicStatus;
@dynamic blockType;
@dynamic text;
@dynamic artists;
@dynamic fileID;
@dynamic soundcloudUrl;
@dynamic linkUrl;
@dynamic linkType;
@dynamic contentID;
@dynamic downloadType;
@dynamic spotMapTags;
@dynamic scaleX;
@dynamic videoUrl;
@dynamic showContent;
@dynamic altText;
@dynamic copyright;

+ (NSString *)coreDataEntityName {
  return NSStringFromClass([self class]);
}

+ (instancetype)insertNewObjectFrom:(id)entity {
  return [self insertNewObjectFrom:entity fileManager:[[XMMOfflineFileManager alloc] init]];
}

+ (instancetype)insertNewObjectFrom:(id)entity fileManager:(XMMOfflineFileManager *)fileManager {
  return [self insertNewObjectFrom:entity fileManager:fileManager completion:nil];
}

+ (instancetype)insertNewObjectFrom:(id)entity
                        fileManager:(XMMOfflineFileManager *)fileManager
                         completion:(void(^)(NSString *url, NSData *data, NSError *error))completion {
  XMMContentBlock *contentBlock = (XMMContentBlock *)entity;
  XMMCDContentBlock *savedContentBlock = nil;
  
  // check if object already exists
  NSArray *objects = [[XMMOfflineStorageManager sharedInstance] fetch:[[self class] coreDataEntityName]
                                                               jsonID:contentBlock.ID];
  if (objects.count > 0) {
    savedContentBlock = objects.firstObject;
  } else {
    savedContentBlock = [NSEntityDescription insertNewObjectForEntityForName:[[self class] coreDataEntityName]
                                                      inManagedObjectContext:[XMMOfflineStorageManager sharedInstance].managedObjectContext];
  }
  
  savedContentBlock.jsonID = contentBlock.ID;
  savedContentBlock.title = contentBlock.title;
  savedContentBlock.publicStatus = [NSNumber numberWithBool:contentBlock.publicStatus];
  savedContentBlock.blockType = [NSNumber numberWithInt:contentBlock.blockType];
  savedContentBlock.text = contentBlock.text;
  savedContentBlock.artists = contentBlock.artists;
  savedContentBlock.fileID = contentBlock.fileID;
  if (contentBlock.fileID) {
    [fileManager saveFileFromUrl:contentBlock.fileID completion:completion];
  }
  savedContentBlock.soundcloudUrl = contentBlock.soundcloudUrl;
  savedContentBlock.linkUrl = contentBlock.linkUrl;
  savedContentBlock.linkType = [NSNumber numberWithInt:contentBlock.linkType];
  savedContentBlock.contentID = contentBlock.contentID;
  savedContentBlock.downloadType = [NSNumber numberWithInt:contentBlock.downloadType];
  savedContentBlock.spotMapTags = contentBlock.spotMapTags;
  savedContentBlock.scaleX = [NSNumber numberWithDouble:contentBlock.scaleX];
  savedContentBlock.videoUrl = contentBlock.videoUrl;
  if (contentBlock.videoUrl && ![contentBlock.videoUrl containsString:@"youtu"]
      && ![contentBlock.videoUrl containsString:@"vimeo"]) {
    [fileManager saveFileFromUrl:contentBlock.videoUrl completion:completion];
  }
  savedContentBlock.showContent = [NSNumber numberWithBool:contentBlock.showContent];
  savedContentBlock.altText = contentBlock.altText;
  savedContentBlock.copyright = contentBlock.copyright;
  
  [[XMMOfflineStorageManager sharedInstance] save];
  
  return savedContentBlock;
}

@end
