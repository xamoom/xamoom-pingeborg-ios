//
//  XMMContentFilter.h
//  XamoomSDK
//
//  Created by Raphael Seher on 23/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMFilterBuilder : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, copy) NSDate *fromDate;
@property (nonatomic, copy) NSDate *toDate;
@property (nonatomic, copy) NSString *relatedSpotID;

@end

@interface XMMFilter : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSArray *tags;
@property (nonatomic, copy, readonly) NSDate *fromDate;
@property (nonatomic, copy, readonly) NSDate *toDate;
@property (nonatomic, copy, readonly) NSString *relatedSpotID;

- (instancetype)init;
- (instancetype)initWithBuilder:(XMMFilterBuilder *)builder;
+ (instancetype)makeWithBuilder:(void (^)(XMMFilterBuilder *builder))updateBlock;

@end
