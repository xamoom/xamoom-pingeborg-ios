//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import "XMMRestResource.h"

@interface XMMQuery : NSObject

@property (strong, nonatomic) NSURL *baseUrl;

- (instancetype)initWithBaseUrl:(NSURL *)url;

- (NSURL *)urlWithResource:(Class <XMMRestResource>)resourceClass;

- (NSURL *)urlWithResource:(Class)resourceClass id:(NSString *)resourceId;

- (NSURL *)addQueryParameterToUrl:(NSURL *)url name:(NSString *)name value:(NSString *)value;

- (NSURL *)addQueryParametersToUrl:(NSURL *)url parameters:(NSDictionary *)parameters;

@end
