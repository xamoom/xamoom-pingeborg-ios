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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "XMMRSSEntry.h"
#import "NSString+HTML.h"
#import "QRCodeReaderViewController.h"
#import "XMMError.h"
#import "XMMResponseGetById.h"
#import "XMMResponseGetByLocationIdentifier.h"
#import "XMMResponseGetByLocation.h"
#import "XMMResponseGetByLocationItem.h"
#import "XMMResponseGetSpotMap.h"
#import "XMMResponseGetSpotMapItem.h"
#import "XMMResponseStyle.h"
#import "XMMResponseMenuItem.h"
#import "XMMResponseContent.h"
#import "XMMResponseContentBlock.h"
#import "XMMResponseContentBlockType0.h"
#import "XMMResponseContentBlockType1.h"
#import "XMMResponseContentBlockType2.h"
#import "XMMResponseContentBlockType3.h"
#import "XMMResponseContentBlockType4.h"
#import "XMMResponseContentBlockType5.h"
#import "XMMResponseContentBlockType6.h"
#import "XMMResponseContentBlockType7.h"
#import "XMMResponseContentBlockType8.h"
#import "XMMResponseContentBlockType9.h"
#import "XMMResponseContentList.h"
#import "XMMResponseClosestSpot.h"

@class XMMResponseGetById;
@class XMMResponseGetByLocation;
@class XMMResponseGetByLocationIdentifier;
@class XMMResponseGetSpotMap;
@class XMMResponseContentList;
@class XMMResponseClosestSpot;

#pragma mark - XMMEnduserApi

extern NSString * const kXamoomAPIBaseUrl;
extern NSString * const kApiBaseURLString;

/**
 `XMMEnduserApi` is the main part of the xamoom-ios-sdk. You can use it to send api request to the xamoom-api.
 
 For everything just use the shared instance: [XMMEnduserApi sharedInstance].
 
 To get the results from the api calls, you have to listen to the delegate methods. Set the delegate like this:
 
 `[XMMEnduserApi sharedInstance].delegate = self;`
 
 If you want to use the build-in CoreData Code, you have to call the initCoreData method.
 
 `[[XMMEnduserApi sharedInstance] initCoreData];`
 
 */
@interface XMMEnduserApi : NSObject <NSXMLParserDelegate>

#pragma mark Properties
/// @name Properties

/**
 The base url of xamoom api.
 (readonly)
 */
@property (readonly) NSURL *apiBaseURL;
/**
 The preferred language of the user.
 */
@property NSString *systemLanguage;
/**
 String with the title of the qr code view cancel button.
 */
@property NSString* qrCodeViewControllerCancelButtonTitle;
/**
 A shared instance from XMMEnduserApi.
 */
+ (XMMEnduserApi *) sharedInstance;

/// @name Inits

/**
 Inits the XMMEnduserApi: generates the apiBaseUrl and the rssBaseUrl and gets the preferred systemLanguage.
 
 @return id
 */
-(instancetype)init NS_DESIGNATED_INITIALIZER;

#pragma mark - public methods

/**
 * Set your API Key from the xamoom-system.
 */
- (void)setApiKey:(NSString*)apiKey;

/// @name API Calls

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param contentId   The id of the content from xamoom backend.
 @param style       True or False for returning the style from xamoom backend.
 @param menu        True or False for returning the menu from xamoom backend.
 @param language    The requested language of the content from xamoom backend.
 @param full        True or false for returning "unsynced" data or not
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseGetById
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)contentWithContentId:(NSString*)contentId includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language full:(BOOL)full completion:(void(^)(XMMResponseGetById *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom with a unique locationIdentifier (code saved on NFC or QR). If the selected language is not available the
 default language will be returned.
 
 @param locationIdentifier  The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend.
 @param style               True or False for returning the style from xamoom backend.
 @param menu                True of False for returning the menu from xamoom backend.
 @param language            The requested language of the content from xamoom backend.
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseGetByLocationIdentifier
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)contentWithLocationIdentifier:(NSString*)locationIdentifier includeStyle:(BOOL)style includeMenu:(BOOL)menu withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocationIdentifier *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom with a location (lat & lon). If the selected language is not available the
 default language will be returned.
 
 @param lat         The latitude of a location.
 @param lon         The longitude of a location.
 @param language    The requested language of the content from xamoom backend
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseGetByLocation
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)contentWithLat:(NSString*)lat withLon:(NSString*)lon withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetByLocation *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom with params to get a list of all items, so you can show them on a map.
 
 @param systemId    The id of the wanted system.
 @param mapTags     The Tags of the wanted spots.
 @param language    The requested language of the content from xamoom backend
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseGetSpotMap
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)spotMapWithMapTags:(NSArray*)mapTags withLanguage:(NSString*)language completion:(void(^)(XMMResponseGetSpotMap *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom with a unique contentId. If the selected language is not available the default language will be returned.
 
 @param systemId   The id of the system from xamoom.
 @param language   The requested language of the content from xamoom backend
 @param pageSize   Number of items you will get returned
 @param cursor     Cursor for paging
 @param tags       Tags as an array
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseContentList
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)contentListWithPageSize:(int)pageSize withLanguage:(NSString*)language withCursor:(NSString*)cursor withTags:(NSArray*)tags completion:(void(^)(XMMResponseContentList *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom with a location and returns the closest spots.
 If the selected language is not available the default language will be returned.
 
 @param lat       Latitude
 @param lon       Longitude
 @param radius    Radius in decimenter
 @param limit     Limit of the results
 @param language  The requested language of the content from xamoom backend
 @param completionHandler CompletionHandler returns the result
 
 - *param1* result The result from xamoom backend as XMMResponseClosestSpot
 @param errorHandler ErrorHandler returns an error if one occures
 
 - *param1* error A XMMError with error informations
 @return void
 */
- (void)closestSpotsWithLat:(float)lat withLon:(float)lon withRadius:(int)radius withLimit:(int)limit withLanguage:(NSString*)language completion:(void(^)(XMMResponseClosestSpot *result))completionHandler error:(void(^)(XMMError *error))errorHandler;

/**
 Makes an api call to xamoom when a user clicks a geofenced content for analytics.
 
 @param requestedLanguage
 @param deliveredLanguage
 @param systemId
 @param systemName
 @param contentId
 @param contentName
 @param spotId
 @param spotName
 */
- (void)geofenceAnalyticsMessageWithRequestedLanguage:(NSString*)requestedLanguage withDeliveredLanguage:(NSString*)deliveredLanguage withSystemId:(NSString*)systemId withSystemName:(NSString*)sytemName withContentId:(NSString*)contentId withContentName:(NSString*)contentName withSpotId:(NSString*)spotId withSpotName:(NSString*)spotName;

#pragma mark - QRCodeReaderViewController

/// @name QRCodeReaderViewController

/**
 Starts the QRCodeReaderViewController to scan qr codes.
 
 @param viewController          The ViewController from where you want to call the QRCodeReader (usually self)
 @param completionHandler CompletionHandler returns the result
  - *param1* locationIdentifier NSString with only the locaitionIdentifier of the scanned QR
  - *param2* url NSString wiht the complete scanned url
 @return void
 */
- (void)startQRCodeReaderFromViewController:(UIViewController*)viewController didLoad:(void(^)(NSString *locationIdentifier, NSString *url))completionHandler;

@end
