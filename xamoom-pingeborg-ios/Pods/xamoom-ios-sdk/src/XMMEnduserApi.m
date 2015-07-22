//
// Copyright 2015 by Raphael Seher <raphael@xamoom.com>
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

#import "XMMEnduserApi.h"
#import <RestKit/RestKit.h>
#import <dispatch/dispatch.h>

NSString * const kApiBaseURLString = @"https://xamoom-api-dot-xamoom-cloud.appspot.com/_ah/api/";

static XMMEnduserApi *sharedInstance;

@interface XMMEnduserApi () <QRCodeReaderDelegate>

@property NSMutableArray *rssEntries;
@property NSMutableString *element;
@property XMMRSSEntry *rssItem;
@property BOOL isQRCodeScanFinished;
@property dispatch_queue_t backgroundQueue;
@property UIViewController *qrCodeParentViewController;

@end

#pragma mark - XMMEnduserApi

@implementation XMMEnduserApi : NSObject

@synthesize apiBaseURL;

+ (XMMEnduserApi *)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[XMMEnduserApi alloc] init];
  }
  
  return sharedInstance;
}

-(instancetype)init {
  self = [super init];
  apiBaseURL = [NSURL URLWithString:kApiBaseURLString];
  self.systemLanguage = [NSLocale preferredLanguages][0];
  self.qrCodeViewControllerCancelButtonTitle = @"Cancel";
  
  //create RKObjectManager
  RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:apiBaseURL];
  [RKObjectManager setSharedManager:objectManager];
  return self;
}

- (void)setApiKey:(NSString*)apiKey {
  //set JSON-Type and Authorization Header
  [RKObjectManager sharedManager].requestSerializationMIMEType = RKMIMETypeJSON;
  [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Authorization" value:apiKey];
}


#pragma mark public methods
#pragma mark API calls

- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full completion:(void(^)(XMMResponseGetById *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSDictionary *queryParams = @{@"content_id":contentId,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                @"full":(full) ? @"True" : @"False",
                                };
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_content_id_full";
  
  [self apiPostWithPath:path andDescriptor:[XMMResponseGetById contentDescriptor] andParams:queryParams completion:completionHandler error:errorHandler];
}

- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocationIdentifier *result))completionHandler error:(void(^)(XMMError *error))errorHandler{
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSDictionary *queryParams = @{@"location_identifier":locationIdentifier,
                                @"include_style":(style) ? @"True" : @"False",
                                @"include_menu":(menu) ? @"True" : @"False",
                                @"language":language,
                                };
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location_identifier";
  
  [self apiPostWithPath:path andDescriptor:[XMMResponseGetByLocationIdentifier contentDescriptor] andParams:queryParams completion:completionHandler error:errorHandler];
}

- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocation *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSDictionary *queryParams = @{@"location":
                                  @{@"lat":lat,
                                    @"lon":lon,
                                    },
                                @"language":language,
                                };
  
  
  NSString *path = @"xamoomEndUserApi/v1/get_content_by_location";
  
  [self apiPostWithPath:path andDescriptor:[XMMResponseGetByLocation contentDescriptor] andParams:queryParams completion:completionHandler error:errorHandler];
}

- (void)spotMapWithMapTags:(NSArray *)mapTags withLanguage:(NSString *)language completion:(void(^)(XMMResponseGetSpotMap *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/spotmap/%i/%@/%@", 0, [mapTags componentsJoinedByString:@","], language];
  
  [self apiGetWithPath:path andDescriptor:[XMMResponseGetSpotMap contentDescriptor] andParams:nil completion:completionHandler error:errorHandler];
}

- (void)contentListWithPageSize:(int)pageSize withLanguage:(NSString*)language withCursor:(NSString*)cursor withTags:(NSArray*)tags completion:(void(^)(XMMResponseContentList *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSString* tagsAsString;
  if (tags != nil)
    tagsAsString = [tags componentsJoinedByString:@","];
  else
    tagsAsString = @"null";
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/content_list/%@/%i/%@/%@", language, pageSize, cursor, tagsAsString];
  
  [self apiGetWithPath:path andDescriptor:[XMMResponseContentList contentDescriptor] andParams:nil completion:completionHandler error:errorHandler];
}

- (void)closestSpotsWithLat:(float)lat withLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language completion:(void(^)(XMMResponseClosestSpot *result))completionHandler error:(void(^)(XMMError *error))errorHandler {
  if ([language isEqual:@""]) {
    language = self.systemLanguage;
  }
  
  NSDictionary *queryParams = @{@"location":
                                  @{@"lat":[NSString stringWithFormat:@"%f", lat],
                                    @"lon":[NSString stringWithFormat:@"%f", lon],
                                    },
                                @"radius":[NSString stringWithFormat:@"%d", radius],
                                @"limit":[NSString stringWithFormat:@"%d", limit],
                                @"language":language,
                                };
  
  NSString *path = @"xamoomEndUserApi/v1/get_closest_spots";
  
  [self apiPostWithPath:path andDescriptor:[XMMResponseClosestSpot contentDescriptor] andParams:queryParams completion:completionHandler error:errorHandler];
}

- (void)geofenceAnalyticsMessageWithRequestedLanguage:(NSString*)requestedLanguage withDeliveredLanguage:(NSString*)deliveredLanguage withSystemId:(NSString*)systemId withSystemName:(NSString*)sytemName withContentId:(NSString*)contentId withContentName:(NSString*)contentName withSpotId:(NSString*)spotId withSpotName:(NSString*)spotName {
  NSDictionary *queryParams = @{@"requested_language":requestedLanguage,
                                @"delivered_language":deliveredLanguage,
                                @"system_id":systemId,
                                @"system_name":sytemName,
                                @"content_id":contentId,
                                @"content_name":contentName,
                                @"spot_id":spotId,
                                @"spot_name":spotName,
                                };
  
  NSString *path = [NSString stringWithFormat:@"xamoomEndUserApi/v1/queue_geofence_analytics/"];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:queryParams
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"queue_geofence_analytics successfull");
                                      } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"queue_geofence_analytics Error: %@", error);
                                      }
   ];
}

- (void)apiPostWithPath:(NSString*)path andDescriptor:(RKResponseDescriptor*)descriptor andParams:(NSDictionary*)params completion:(void(^)(id result))completionHandler error:(void(^)(XMMError *error))errorHandler{
  [[RKObjectManager sharedManager] addResponseDescriptor:[XMMError contentDescriptor]];
  [[RKObjectManager sharedManager] addResponseDescriptor:descriptor];
  [[RKObjectManager sharedManager] postObject:nil path:path parameters:params
                                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        NSLog(@"Output: %@", mappingResult.firstObject);
                                        XMMResponseGetById *result = mappingResult.firstObject;
                                        completionHandler(result);
                                      }
                                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSArray *errors = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
                                        errorHandler(errors.firstObject);
                                      }
   ];
}

- (void)apiGetWithPath:(NSString*)path andDescriptor:(RKResponseDescriptor*)descriptor andParams:(NSDictionary*)params completion:(void(^)(id result))completionHandler error:(void(^)(XMMError *error))errorHandler{
  [[RKObjectManager sharedManager] addResponseDescriptor:[XMMError contentDescriptor]];
  [[RKObjectManager sharedManager] addResponseDescriptor:descriptor];
  [[RKObjectManager sharedManager] getObject:nil path:path parameters:params
                                     success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                       NSLog(@"Output: %@", mappingResult.firstObject);
                                       XMMResponseGetById *result = mappingResult.firstObject;
                                       completionHandler(result);
                                     } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                       NSArray *errors = [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey];
                                       errorHandler(errors.firstObject);
                                     }
   ];
}

#pragma mark - QRCodeReaderViewController

- (void)startQRCodeReaderFromViewController:(UIViewController*)viewController didLoad:(void(^)(NSString *locationIdentifier, NSString *url))completionHandler {
  static QRCodeReaderViewController *reader = nil;
  static dispatch_once_t onceToken;
  
  self.qrCodeParentViewController = viewController;
  
  dispatch_once(&onceToken, ^{
    reader                        = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:self.qrCodeViewControllerCancelButtonTitle];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
  });
  
  reader.delegate = self;
  
  //completionblock
  [reader setCompletionWithBlock:^(NSString *resultAsString) {
    if (!self.isQRCodeScanFinished && resultAsString != nil) {
      self.isQRCodeScanFinished = YES;
      [self.qrCodeParentViewController dismissViewControllerAnimated:YES completion:nil];
      completionHandler([self getLocationIdentifierFromURL:resultAsString], resultAsString);
    }
  }];
  
  self.isQRCodeScanFinished = NO;
  [viewController presentViewController:reader animated:YES completion:NULL];
}

-(void)readerDidCancel:(QRCodeReaderViewController *)reader {
  [self.qrCodeParentViewController dismissViewControllerAnimated:YES completion:nil];
  self.isQRCodeScanFinished = YES;
  self.qrCodeParentViewController = nil;
}

- (NSString*)getLocationIdentifierFromURL:(NSString*)URL {
  NSURL* realUrl = [NSURL URLWithString:[self checkUrlPrefix:URL]];
  NSString *path = [realUrl path];
  path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
  return path;
}

- (NSString*)checkUrlPrefix:(NSString*)URL {
  if ([[URL lowercaseString] hasPrefix:@"http://"]) {
    return URL;
  }
  else if ([[URL lowercaseString] hasPrefix:@"https://"]) {
    return URL;
  }
  else {
    return [NSString stringWithFormat:@"http://%@", URL];
  }
}

@end
