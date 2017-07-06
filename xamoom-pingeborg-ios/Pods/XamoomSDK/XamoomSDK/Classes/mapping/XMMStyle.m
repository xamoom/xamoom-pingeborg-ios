//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMStyle.h"
#import "XMMCDStyle.h"

@implementation XMMStyle

static JSONAPIResourceDescriptor *__descriptor = nil;

- (instancetype)init {
  return [self initWithBackgroundColor:@"#FFFFFF"
                highlightTextColor:@"#0000FF"
                textColor:@"#000000"];
}

- (instancetype)initWithBackgroundColor:(NSString *)backgroundHexColor highlightTextColor:(NSString *)highlightFontHexColor textColor:(NSString *)foregroundFontHexColor {
  self = [super init];
  if (self) {
    self.backgroundColor = backgroundHexColor;
    self.highlightFontColor = highlightFontHexColor;
    self.foregroundFontColor = foregroundFontHexColor;
  }
  return self;
}

+ (NSString *)resourceName {
  return @"styles";
}

+ (JSONAPIResourceDescriptor *)descriptor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __descriptor = [[JSONAPIResourceDescriptor alloc] initWithClass:[self class] forLinkedType:@"styles"];
    
    [__descriptor setIdProperty:@"ID"];
    
    [__descriptor addProperty:@"backgroundColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"background-color"]];
    [__descriptor addProperty:@"highlightFontColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"highlight-color"]];
    [__descriptor addProperty:@"foregroundFontColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"foreground-color"]];
    [__descriptor addProperty:@"chromeHeaderColor" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"chrome-header-color"]];
    [__descriptor addProperty:@"customMarker" withDescription:[[JSONAPIPropertyDescriptor alloc] initWithJsonName:@"map-pin"]];
    [__descriptor addProperty:@"icon"];
  });
  
  return __descriptor;
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object {
  return [self initWithCoreDataObject:object excludeRelations:NO];
}

- (instancetype)initWithCoreDataObject:(id<XMMCDResource>)object excludeRelations:(Boolean)excludeRelations {
  self = [self init];
  if (self && object != nil) {
    XMMCDStyle *savedStyle = (XMMCDStyle *)object;
    self.ID = savedStyle.jsonID;
    self.backgroundColor = savedStyle.backgroundColor;
    self.highlightFontColor = savedStyle.highlightFontColor;
    self.foregroundFontColor = savedStyle.foregroundFontColor;
    self.chromeHeaderColor = savedStyle.chromeHeaderColor;
    self.customMarker = savedStyle.customMarker;
    self.icon = savedStyle.icon;
  }
  return self;
}

- (id<XMMCDResource>)saveOffline {
  return [XMMCDStyle insertNewObjectFrom:self];
}

- (void)deleteOfflineCopy {
  [[XMMOfflineStorageManager sharedInstance] deleteEntity:[XMMCDStyle class] ID:self.ID];
}

@end
