//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMQuery.h"
#import <JSONAPI/JSONAPI.h>

@interface XMMRestClient : NSObject

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) XMMQuery *query;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass id:(NSString *)resourceId parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion;

@end
