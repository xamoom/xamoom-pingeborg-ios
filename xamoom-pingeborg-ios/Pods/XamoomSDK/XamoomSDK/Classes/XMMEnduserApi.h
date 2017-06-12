//
// Copyright 2017 by xamoom GmbH <apps@xamoom.com>
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
#import <CoreLocation/CoreLocation.h>
#import <JSONAPI/JSONAPIResourceDescriptor.h>
#import "XMMRestClient.h"
#import "XMMOptions.h"
#import "XMMParamHelper.h"
#import "XMMOfflineApi.h"
#import "XMMSpot.h"
#import "XMMStyle.h"
#import "XMMSystem.h"
#import "XMMMenu.h"
#import "XMMContent.h"
#import "XMMContentBlock.h"
#import "XMMMarker.h"

#pragma mark - XMMEnduserApi

extern NSString * const kApiBaseURLString;


/**
 * `XMMEnduserApi` is the main part of the XamoomSDK. You can use it to send api request to the xamoom-api.
 *
 * Use initWithApiKey: to initialize.
 * 
 * Change the requested language by setting the language. The users language is
 * saved in systemLanguage.
 *
 * Set offline to true, to get results from offline storage.
 */
@interface XMMEnduserApi : NSObject

#pragma mark Properties
/// @name Properties

/**
 * The preferred language of the user.
 */
@property (strong, nonatomic) NSString *systemLanguage;
/**
 * Language used in api calls.
 */
@property (strong, nonatomic) NSString *language;
/**
 * XMMRestClient used to call rest api.
 */
@property (strong, nonatomic) XMMRestClient *restClient;
/**
 * XMMOfflineApi used when offline is set.
 */
@property (strong, nonatomic) XMMOfflineApi *offlineApi;
/**
 * Indicator to use the XMMOfflineApi.
 */
@property (getter=isOffline, nonatomic) BOOL offline;

/// @name Singleton

/**
 * Get the sharedInstance. Works only when you already have an instance
 * created with sharedInstanceWithKey:apikey or set via
 * saveSharedInstance:instance.
 */
+ (instancetype)sharedInstance;

/**
 * Get the sharedInstance, when there is none, creates a new one with apikey.
 *
 * @param apikey Your xamoom api key
 */
+ (instancetype)sharedInstanceWithKey:(NSString *)apikey;

/**
 * Change the saved sharedInstance.
 *
 * @param instance Your XMMEnduserApi instance you want to save
 * @warning will override old instance.
 */
+ (void)saveSharedInstance:(XMMEnduserApi *)instance;

/// @name Initializers

/**
 * Initializes with a apikey. You find your apikey in your xamoom system in
 * Settings.
 * 
 * @param apikey Your xamoom api key
 */
- (instancetype)initWithApiKey:(NSString *)apikey;

/**
 * Initializes with a custom XMMRestClient.
 * 
 * @param restClient Custom XMMRestClient
 */
- (instancetype)initWithRestClient:(XMMRestClient *)restClient;

/// @name API Calls

#pragma mark - public methods

/**
 * API call to get content with specific ID.
 *
 * @param contentID ContentID of xamoom content
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID completion:(void(^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with specific ID and options.
 *
 * @param contentID ContentID of xamoom content
 * @param options XMMContentOptions for call
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithID:(NSString *)contentID options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with specific location-identifier.
 *
 * @param locationIdentifier Locationidentifier from xamoom marker
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with specific location-identifier with options.
 *
 * @param locationIdentifier Locationidentifier from xamoom marker
 * @param options XMMContentOptions for call
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithLocationIdentifier:(NSString *)locationIdentifier options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with beacon.
 *
 * @param major Major of the beacon
 * @param minor Minor of the beacon
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get content with beacon.
 *
 * @param major Major of the beacon
 * @param minor Minor of the beacon
 * @param options XMMContentOptions for call
 * @param completion Completion block called after finishing network request
 * - *param1* content Content from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentWithBeaconMajor:(NSNumber *)major minor:(NSNumber *)minor options:(XMMContentOptions)options completion:(void (^)(XMMContent *content, NSError *error))completion;

/**
 * API call to get contents around location (40m).
 *
 * @param location Location of the user
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param sortOptions XMMContentSortOptions to sort result
 * @param completion Completion block called after finishing network request
 * - *param1* contents Contents from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentsWithLocation:(CLLocation *)location pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get contents with specific tags.
 * 
 * @param tags Array of tags
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param sortOptions XMMContentSortOptions to sort result
 * @param completion Completion block called after finishing network request
 * - *param1* contents Contents from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to fulltext-search contents for name and tags.
 *
 * @param name Name to search for
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param sortOptions XMMContentSortOptions to sort result
 * @param completion Completion block called after finishing network request
 * - *param1* contents Contents from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)contentsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor sort:(XMMContentSortOptions)sortOptions completion:(void (^)(NSArray *contents, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get a spot with specific id.
 *
 * @param spotID SpotId from your xamoom system
 * @param completion Completion block called after finishing network request
 * - *param1* spot The returned spot
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID completion:(void(^)(XMMSpot *spot, NSError *error))completion;

/**
 * API call to get a spot with specific id.
 *
 * @param spotID SpotId from your xamoom system
 * @param options XMMSpotOptions for call
 * @param completion Completion block called after finishing network request
 * - *param1* spot The returned spot
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotWithID:(NSString *)spotID options:(XMMSpotOptions)options completion:(void(^)(XMMSpot *spot, NSError *error))completion;

/**
 * API call to get spots inside radius of a location.
 * 
 * @param location Location of the user
 * @param radius Radius in meter
 * @param options XMMSpotOptions to get markers or content
 * @param sortOptions XMMSpotSortOptions to sort the results
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get spots inside radius of a location.
 *
 * @param location Location of the user
 * @param radius Radius in meter
 * @param options XMMSpotOptions to get markers or content
 * @param sortOptions XMMSpotSortOptions to sort the results
 * @param completion Completion block called after finishing network request
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotsWithLocation:(CLLocation *)location radius:(int)radius options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions pageSize:(int)pageSize cursor:(NSString *)cursor completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get spots with specific tags. Returns max. 100 spots.
 *
 * @param tags Array of tags
 * @param options XMMSpotOptions to get markers or content
 * @param sortOptions XMMSpotSortOptions to sort the results
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to get spots with specific tags.
 *
 * @param tags Array of tags
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param options XMMSpotOptions to get markers or content
 * @param sortOptions XMMSpotSortOptions to sort results
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotsWithTags:(NSArray *)tags pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call to fulltext-search spots by name.
 *
 * @param name Name to search for
 * @param pageSize PageSize you want to get from xamoom cloud
 * @param cursor Needed when paging, can be null
 * @param options XMMSpotOptions to get markers or content
 * @param sortOptions XMMSpotSortOptions to sort results
 * @param completion Completion block called after finishing network request
 * - *param1* spots Spots from xamoom system
 * - *param2* hasMore True if more items on xamoom cloud
 * - *param3* cursor Cursor for paging
 * - *param4* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)spotsWithName:(NSString *)name pageSize:(int)pageSize cursor:(NSString *)cursor options:(XMMSpotOptions)options sort:(XMMSpotSortOptions)sortOptions completion:(void (^)(NSArray *spots, bool hasMore, NSString *cursor, NSError *error))completion;

/**
 * API call that returns your system.
 * 
 * @param completion Completion block called after finishing network request
 * - *param1* system System from xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)systemWithCompletion:(void (^)(XMMSystem *system, NSError *error))completion;

/**
 * API call that returns your system settings.
 *
 * @param settingsID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* settings System settings from your xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)systemSettingsWithID:(NSString *)settingsID completion:(void (^)(XMMSystemSettings *settings, NSError *error))completion;

/**
 * API call that returns your system style.
 *
 * @param styleID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* style System style from your xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)styleWithID:(NSString *)styleID completion:(void (^)(XMMStyle *style, NSError *error))completion;

/**
 * API call that returns your menu.
 *
 * @param menuID ID you get from systemWithCompletion:
 * @param completion Completion block called after finishing network request
 * - *param1* style System style from your xamoom system
 * - *param2* error NSError, can be null
 * @return SessionDataTask used to download from the backend.
 */
- (NSURLSessionDataTask *)menuWithID:(NSString *)menuID completion:(void (^)(XMMMenu *menu, NSError *error))completion;

@end
