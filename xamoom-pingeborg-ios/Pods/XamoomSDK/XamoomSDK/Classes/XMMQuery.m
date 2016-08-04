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
