//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMRestClient.h"
#import "JSONAPIErrorResource.h"

@implementation XMMRestClient

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session {
  self = [super init];
  self.query = [[XMMQuery alloc] initWithBaseUrl:baseUrl];
  self.session = session;
  return self;
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  return [self makeRestCall:requestUrl completion:completion];
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  return [self makeRestCall:requestUrl completion:completion];
}

- (NSURLSessionDataTask *)fetchResource:(Class)resourceClass id:(NSString *)resourceId parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURL *requestUrl = [self.query urlWithResource:resourceClass id:resourceId];
  requestUrl = [self.query addQueryParametersToUrl:requestUrl parameters:parameters];
  return [self makeRestCall:requestUrl completion:completion];
}

- (NSURLSessionDataTask *)makeRestCall:(NSURL *)url completion:(void (^)(JSONAPI *result, NSError *error))completion {
  NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    JSONAPI *jsonApi;
    
    if (error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(jsonApi, error);
      });
      
      return;
    }
    
    jsonApi = [self jsonApiFromData:data];
    
    if (jsonApi.errors != nil) {
      NSLog(@"JSONAPI Error: %@", jsonApi.errors);
      JSONAPIErrorResource *apierror = jsonApi.errors.firstObject;
      
      NSDictionary *userInfo = @{@"code":apierror.code,
                                 @"status":apierror.status,
                                 @"title":apierror.title,
                                 @"detail":apierror.detail,};
      NSError *error = [NSError errorWithDomain:@"com.xamoom"
                                           code:[apierror.code intValue]
                                       userInfo:userInfo];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completion(jsonApi, error);
      });
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(jsonApi, error);
    });
  }];
  
  [task resume];
  return task;
}

- (JSONAPI *)jsonApiFromData:(NSData *)data {
  NSError *jsonError;
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
  JSONAPI *jsonApi = [JSONAPI jsonAPIWithDictionary:jsonDict];
  return jsonApi;
}

@end
