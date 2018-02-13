//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMEnduserApi.h"
#import <dispatch/dispatch.h>

NSString * const kApiBaseURLString = @"https://xamoom-cloud.appspot.com/_api/v2/consumer";
NSString * const kHTTPContentType = @"application/vnd.api+json";
NSString * const kHTTPUserAgent = @"XamoomSDK iOS";
NSString * const kEphemeralIdKey = @"com.xamoom.EphemeralId";
NSString * const kEphemeralIdHttpHeaderName = @"X-Ephemeral-Id";
NSString * const kReasonHttpHeaderName = @"X-Reason";


@interface XMMEnduserApi () <XMMRestClientDelegate>

@property (nonatomic, strong) NSString *ephemeralId;

@end

#pragma mark - XMMEnduserApi

/**
 * Shared instance.
 */
static XMMEnduserApi *sharedInstance;

@implementation XMMEnduserApi : NSObject

#pragma mark - shared instance

+ (instancetype)sharedInstanceWithKey:(NSString *)apikey {
  NSAssert(apikey != nil, @"apikey is nil. Please use an apikey");
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] initWithApiKey:apikey];
  });
  return sharedInstance;
}

+ (instancetype)sharedInstance {
  NSAssert(sharedInstance != nil, @"SharedInstance is nil. Use sharedInstanceWithKey:apikey or saveSharedInstance:instance");
  return sharedInstance;
}

+ (void)saveSharedInstance:(XMMEnduserApi *)instance {
  sharedInstance = instance;
}

#pragma mark - init

- (instancetype)initWithApiKey:(NSString *)apikey {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [XMMOfflineStorageManager sharedInstance];
  
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  [config setHTTPAdditionalHeaders:@{@"Content-Type":kHTTPContentType,
                                     @"User-Agent":[self customUserAgentFrom:@""],
                                     @"APIKEY":apikey,}];
  
  self.restClient = [[XMMRestClient alloc] initWithBaseUrl:[NSURL URLWithString: kApiBaseURLString]
                                                   session:[NSURLSession sessionWithConfiguration:config]];
  self.restClient.delegate = self;
  [self setupResources];
  return self;
}

- (instancetype)initWithRestClient:(XMMRestClient *)restClient {
  self = [super init];
  self.systemLanguage = [self systemLanguageWithoutRegionCode];
  self.language = self.systemLanguage;
  self.offlineApi = [[XMMOfflineApi alloc] init];
  [XMMOfflineStorageManager sharedInstance];
  
  self.restClient = restClient;
  self.restClient.delegate = self;
  [self setupResources];
  return self;
}

- (NSString *)systemLanguageWithoutRegionCode {
  NSString *preferredLanguage = [NSLocale preferredLanguages][0];
  return [preferredLanguage substringWithRange:NSMakeRange(0, 2)];
}

- (void)setupResources {
  [JSONAPIResourceDescriptor addResource:[XMMSystem class]];
  [JSONAPIResourceDescriptor addResource:[XMMSystemSettings class]];
  [JSONAPIResourceDescriptor addResource:[XMMStyle class]];
  [JSONAPIResourceDescriptor addResource:[XMMMenu class]];
  [JSONAPIResourceDescriptor addResource:[XMMContent class]];
  [JSONAPIResourceDescriptor addResource:[XMMContentBlock class]];
  [JSONAPIResourceDescriptor addResource:[XMMSpot class]];
  [JSONAPIResourceDescriptor addResource:[XMMMarker class]];
}

#pragma mark - public methods

#pragma mark content calls

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID completion:(void(^)(XMMContent *content, NSError *error))completion {
  return [self contentWithID:contentID options:0 reason:0 completion:completion];
}

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  return [self contentWithID:contentID options:options reason:0 completion:completion];
}

- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID
                                options:(XMMContentOptions)options
                                 reason:(XMMContentReason)reason
                             completion:(void (^)(XMMContent *, NSError *))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithID:contentID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  if (options > 0) {
    params = [XMMParamHelper addContentOptionsToParams:params options:options];
  }
  
  NSMutableDictionary *headers = [self httpHeadersWithEphemeralId];
  headers = [self addHeaderForReason:headers
                              reason:reason];
  
  return [self.restClient fetchResource:[XMMContent class]
                                     id:contentID
                             parameters:params
                                headers:headers
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMContent *content = result.resource;
                               
                               if (completion) {
                                 completion(content, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *content, NSError *error))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:0
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:options
                                  conditions:nil
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options conditions:(NSDictionary *)conditions completion:(void (^)(XMMContent *, NSError *))completion {
  return [self contentWithLocationIdentifier:locationIdentifier
                                     options:options
                                  conditions:conditions
                                      reason:0
                                  completion:completion];
}

- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier
                                                options:(XMMContentOptions)options
                                             conditions:(NSDictionary *)conditions
                                                 reason:(XMMContentReason)reason
                                             completion:(void (^)(XMMContent *,
                                                                  NSError *))completion {
  if (self.isOffline) {
    [self.offlineApi contentWithLocationIdentifier:locationIdentifier completion:completion];
    return nil;
  }
  NSMutableDictionary *mutableConditions = nil;
  if (conditions == nil) {
    mutableConditions = [[NSMutableDictionary alloc] init];
  } else {
    mutableConditions = [conditions mutableCopy];
  }
  
  [mutableConditions setObject:[[NSDate alloc] init] forKey:@"x-datetime"];
  conditions = mutableConditions;
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language locationIdentifier:locationIdentifier];
  params = [XMMParamHelper addContentOptionsToParams:params options:options];
  params = [XMMParamHelper addConditionsToParams:params conditions:conditions];
  
  NSMutableDictionary *headers = [self httpHeadersWithEphemeralId];
  headers = [self addHeaderForReason:headers
                              reason:reason];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:headers
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMContent *content = result.resource;
                               
                               if (completion) {
                                 completion(content, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] options:options completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options conditions:(NSDictionary *)conditions completion:(void (^)(XMMContent *, NSError *))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor] options:options conditions:conditions completion:completion];
}

- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options conditions:(NSDictionary *)conditions reason:(XMMContentReason)reason completion:(void (^)(XMMContent *, NSError *))completion {
  return [self contentWithLocationIdentifier:[NSString stringWithFormat:@"%@|%@", major, minor]
                                     options:options
                                  conditions:conditions
                                      reason:reason
                                  completion:completion];
}

#pragma mark contents calls

- (NSURLSessionDataTask *)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi contentsWithLocation:location pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self contentsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions filter:nil completion:completion];
}

- (NSURLSessionDataTask *)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions filter:(XMMFilter *)filter completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.tags = tags;
    
    builder.name = filter.name;
    builder.fromDate = filter.fromDate;
    builder.toDate = filter.toDate;
    builder.relatedSpotID = filter.relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions filter:filter completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self contentsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions filter:nil completion:completion];
}

- (NSURLSessionDataTask *)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions filter:(XMMFilter *)filter completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.name = name;
    
    builder.tags = filter.tags;
    builder.fromDate = filter.fromDate;
    builder.toDate = filter.toDate;
    builder.relatedSpotID = filter.relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions filter:filter completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)contentsFrom:(NSDate *)fromDate to:(NSDate *)toDate relatedSpot:(NSString *)relatedSpotID pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion {
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.fromDate = fromDate;
    builder.toDate = toDate;
    builder.relatedSpotID = relatedSpotID;
  }];
  
  if (self.isOffline) {
    [self.offlineApi contentsFrom:fromDate to:toDate pageSize:pageSize cursor:cursor sort:sortOptions filter:filters completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addContentSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMContent class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, NO, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

#pragma mark spot calls

- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID completion:(void (^)(XMMSpot *, NSError *))completion {
  return [self spotWithID:spotID options:XMMSpotOptionsNone completion:completion];
}

- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID options:(XMMSpotOptions)options completion:(void(^)(XMMSpot *spot, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotWithID:spotID completion:completion];
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  
  return [self.restClient fetchResource:[XMMSpot class]
                                     id:spotID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSpot *spot = result.resource;
                               
                               if (completion) {
                                 completion(spot, error);
                               }
                             }];
}

#pragma mark spots calls

- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self spotsWithLocation:location radius:radius options:options sort:sortOptions pageSize:0 cursor:nil completion:completion];
}

- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotsWithLocation:location radius:radius pageSize:pageSize cursor:cursor completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language location:location radius:radius];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  return [self spotsWithTags:tags pageSize:100 cursor:nil options:options sort:sortOptions completion:completion];
}

- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  
  if (self.isOffline) {
    [self.offlineApi spotsWithTags:tags pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.tags = tags;
  }];
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)spotsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi spotsWithName:name pageSize:pageSize cursor:cursor sort:sortOptions completion:completion];
    return nil;
  }
  
  XMMFilter *filters = [XMMFilter makeWithBuilder:^(XMMFilterBuilder *builder) {
    builder.name = name;
  }];
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  params = [XMMParamHelper addFiltersToParams:params filters:filters];
  params = [XMMParamHelper addPagingToParams:params pageSize:pageSize cursor:cursor];
  params = [XMMParamHelper addSpotOptionsToParams:params options:options];
  params = [XMMParamHelper addSpotSortOptionsToParams:params options:sortOptions];
  
  return [self.restClient fetchResource:[XMMSpot class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, false, nil, error);
                                 return;
                               }
                               
                               NSString *hasMoreValue = [result.meta objectForKey:@"has-more"];
                               bool hasMore = [hasMoreValue boolValue];
                               NSString *cursor = [result.meta objectForKey:@"cursor"];
                               
                               if (completion) {
                                 completion(result.resources, hasMore, cursor, error);
                               }
                             }];
}

#pragma mark system calls

- (NSURLSessionDataTask *)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi systemWithCompletion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  return [self.restClient fetchResource:[XMMSystem class]
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSystem *system = result.resource;
                               
                               if (completion) {
                                 completion(system, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi systemSettingsWithID:settingsID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMSystemSettings class]
                                     id:settingsID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMSystemSettings *settings = result.resource;
                               
                               if (completion) {
                                 completion(settings, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *style, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi styleWithID:styleID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMStyle class]
                                     id:styleID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMStyle *style = result.resource;
                               
                               if (completion) {
                                 completion(style, error);
                               }
                             }];
}

- (NSURLSessionDataTask *)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *menu, NSError *error))completion {
  if (self.isOffline) {
    [self.offlineApi menuWithID:menuID completion:completion];
    return nil;
  }
  
  NSDictionary *params = [XMMParamHelper paramsWithLanguage:self.language];
  
  return [self.restClient fetchResource:[XMMMenu class]
                                     id:menuID
                             parameters:params
                                headers:[self httpHeadersWithEphemeralId]
                             completion:^(JSONAPI *result, NSError *error) {
                               if (error && completion) {
                                 completion(nil, error);
                                 return;
                               }
                               
                               XMMMenu *menu = result.resource;
                               
                               if (completion) {
                                 completion(menu, error);
                               }
                             }];
}

#pragma mark - XMMRestClientDelegate

- (void)gotEphemeralId:(NSString *)ephemeralId {
  if ([self getEphemeralId] == nil ||
      ![[self getEphemeralId] isEqualToString:ephemeralId]) {
    _ephemeralId = ephemeralId;
    NSUserDefaults *userDefaults = [self getUserDefaults];
    [userDefaults setObject:ephemeralId forKey:kEphemeralIdKey];
    [userDefaults synchronize];
  }
}

#pragma mark - EphemeralId

- (NSMutableDictionary *)addHeaderForReason:(NSMutableDictionary *)headers
                                     reason:(XMMContentReason)reason {
  if (reason > 0) {
    [headers setValue:[NSString stringWithFormat:@"%ld", (long)reason]
               forKey:kReasonHttpHeaderName];
  }
  return headers;
}

- (NSMutableDictionary *)httpHeadersWithEphemeralId {
  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  if (_ephemeralId != nil) {
    [headers setObject:_ephemeralId forKey:kEphemeralIdHttpHeaderName];
  }
  return headers;
}

- (NSString *)getEphemeralId {
  if (_ephemeralId != nil) {
    return _ephemeralId;
  }
  
  _ephemeralId = [[self getUserDefaults] objectForKey:kEphemeralIdKey];
  return _ephemeralId;
}

- (NSUserDefaults *)getUserDefaults {
  if (_userDefaults == nil) {
    _userDefaults = [NSUserDefaults standardUserDefaults];
  }
  return _userDefaults;
}

#pragma mark - Helper

- (NSString *)customUserAgentFrom:(NSString *)appName {
  NSBundle *bundle = [NSBundle bundleForClass:[XMMEnduserApi class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  NSDictionary *infoDict = [nibBundle infoDictionary];
  NSString *sdkVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
  
  if (appName == nil) {
    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
  }
  NSData *asciiStringData = [appName dataUsingEncoding:NSASCIIStringEncoding
                                  allowLossyConversion:YES];
  appName = [[NSString alloc] initWithData:asciiStringData
                                  encoding:NSASCIIStringEncoding];
  NSString *customUserAgent = [NSString stringWithFormat:@"%@|%@|%@",
                               kHTTPUserAgent,
                               appName,
                               sdkVersion];
  return customUserAgent;
}

@end
