//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock.h"
#import "XMMCDContentBlock.h"

@implementation XMMContentBlock

+ (NSString *)resourceName {
  return @"contentblocks";
}

static JSONAPIResourceDescriptor *__descriptor = nil;

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"contentblocks"];
    
    [__descriptor setIdProperty:@"ID"];
    [__descriptor addProperty:@"title" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"title"]];
    [__descriptor addProperty:@"blockType" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"block-type"]];
    [__descriptor addProperty:@"publicStatus" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"is-public"]];
    [__descriptor addProperty:@"text"];
    [__descriptor addProperty:@"artists"];
    [__descriptor addProperty:@"fileID" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"file-id"]];
    [__descriptor addProperty:@"soundcloudUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"soundcloud-url"]];
    [__descriptor addProperty:@"linkType" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"link-type"]];
    [__descriptor addProperty:@"linkUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"link-url"]];
    [__descriptor addProperty:@"contentID" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"content-id"]];
    [__descriptor addProperty:@"downloadType" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"download-type"]];
    [__descriptor addProperty:@"spotMapTags" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"spot-map-tags"]];
    [__descriptor addProperty:@"scaleX" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"scale-x"]];
    [__descriptor addProperty:@"videoUrl" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"video-url"]];
    [__descriptor addProperty:@"showContent" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"should-show-content-on-spotmap"]];
    [__descriptor addProperty:@"altText" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"alt-text"]];
    [__descriptor addProperty:@"copyright" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"copyright"]];
    [__descriptor addProperty:@"contentListTags" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"content-list-tag"]];
    [__descriptor addProperty:@"contentListPageSize" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"content-list-page-size"]];
    [__descriptor addProperty:@"contentListSortAsc" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"content-list-sort-asc"]];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDContentBlock *savedBlock = (XMMCDContentBlock *)object;
    self.ID = savedBlock.jsonID;
    self.title = savedBlock.title;
    self.publicStatus = [savedBlock.publicStatus boolValue];
    self.blockType = [savedBlock.blockType intValue];
    self.text = savedBlock.text;
    self.artists = savedBlock.artists;
    self.fileID = savedBlock.fileID;
    self.soundcloudUrl = savedBlock.soundcloudUrl;
    self.linkUrl = savedBlock.linkUrl;
    self.linkType = [savedBlock.linkType intValue];
    self.contentID = savedBlock.contentID;
    self.downloadType = [savedBlock.downloadType intValue];
    self.spotMapTags = savedBlock.spotMapTags;
    self.scaleX = [savedBlock.scaleX doubleValue];
    self.videoUrl = savedBlock.videoUrl;
    self.showContent = [savedBlock.showContent boolValue];
    self.altText = savedBlock.altText;
    self.copyright = savedBlock.copyright;
    self.contentListTags = savedBlock.contentListTags;
    self.contentListPageSize = [savedBlock.contentListPageSize intValue];
    self.contentListSortAsc = [savedBlock.contentListSortAsc boolValue];
  }
  return self;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDContentBlock insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDContentBlock class] ID:self.ID];
}

@end
