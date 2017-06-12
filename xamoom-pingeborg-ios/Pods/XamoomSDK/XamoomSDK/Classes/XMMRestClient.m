//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

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
