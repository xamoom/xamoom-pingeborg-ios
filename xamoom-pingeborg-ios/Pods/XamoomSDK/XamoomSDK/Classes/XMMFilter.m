//
//  XMMContentFilter.m
//  XamoomSDK
//
//  Created by Raphael Seher on 23/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMFilter.h"

@implementation XMMFilterBuilder

- (instancetype)init {
  if (self = [super init]) {
    _name = nil;
    _tags = nil;
    _fromDate = nil;
    _toDate = nil;
    _relatedSpotID = nil;
  }
  
  return self;
}

@end

@implementation XMMFilter

- (instancetype)initWithBuilder:(XMMFilterBuilder *)builder {
  if (self = [super init]) {
    _name = builder.name;
    _tags = builder.tags;
    _fromDate = builder.fromDate;
    _toDate = builder.toDate;
    _relatedSpotID = builder.relatedSpotID;
  }
  
  return self;
}

- (instancetype)init {
  XMMFilterBuilder *builder = [XMMFilterBuilder new];
  return [self initWithBuilder:builder];
}

+ (instancetype)makeWithBuilder:(void (^)(XMMFilterBuilder *builder))updateBlock {
  XMMFilterBuilder *builder = [XMMFilterBuilder new];
  updateBlock(builder);
  return [[XMMFilter alloc] initWithBuilder:builder];
}

@end
