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

#import <Foundation/Foundation.h>
#import "XMMQuery.h"
#import <JSONAPI/JSONAPI.h>

@interface XMMRestClient : NSObject

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) XMMQuery *query;

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl session:(NSURLSession *)session;

- (void)fetchResource:(Class)resourceClass completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (void)fetchResource:(Class)resourceClass parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion;

- (void)fetchResource:(Class)resourceClass id:(NSString *)resourceId parameters:(NSDictionary *)parameters completion:(void (^)(JSONAPI *result, NSError *error))completion;

@end
