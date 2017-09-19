//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMQuery.h"

@implementation XMMQuery

- (instancetype)initWithBaseUrl:(NSURL *)url {
  self = [super init];
  self.baseUrl = url;
  return self;
}

- (NSURL *)urlWithResource:(Class <XMMRestResource>)resourceClass {
  NSString *resourceName = [resourceClass resourceName];
  return [self.baseUrl URLByAppendingPathComponent:resourceName];
}

- (NSURL *)urlWithResource:(Class)resourceClass id:(NSString *)resourceId {
  NSURL *urlWithResourceName = [self urlWithResource:resourceClass];
  return [urlWithResourceName URLByAppendingPathComponent:resourceId];
}

- (NSURL *)addQueryParametersToUrl:(NSURL *)url parameters:(NSDictionary *)parameters {
  NSMutableArray *parameterArray = [[NSMutableArray alloc] init];
  for(id key in parameters) {
    [parameterArray addObject:[[NSURLQueryItem alloc] initWithName:key value:[parameters valueForKey:key]]];
  }
  return [self addQueryStringToUrl:url query:parameterArray];
}

- (NSURL *)addQueryParameterToUrl:(NSURL *)url name:(NSString *)name value:(NSString *)value {
  return [self addQueryParametersToUrl:url parameters:@{name:value}];
}

- (NSURL *)addQueryStringToUrl:(NSURL *)url query:(NSArray *)queryItems {
  NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
  components.queryItems = queryItems;
  return components.URL;
}

@end
