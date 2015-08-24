![](https://xamoom.com/wp-inhalte/uploads/2015/02/logo-black-claim1.png)


# xamoom-ios-sdk
With the xamoom-ios-sdk we created a simple SDK to let you create apps based on our system.

More informations about xamoom and how xamoom works? Visit our Github page [xamoom Github Wiki](https://github.com/xamoom/xamoom.github.io/wiki)

# Getting Started

* [Download](https://github.com/xamoom/xamoom-ios-sdk/archive/master.zip) the xamoom-ios-sdk and try it
* Read the ["Getting Started"](https://github.com/xamoom/xamoom-ios-sdk/wiki#getting-started) guide in the wiki
* Check out the [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html)
* Check out our sample app: ["pingeborg App"](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

## Manual Installation
Download the xamoom-ios-sdk and add it to your project. Don't forget to install the [dependencies](https://github.com/xamoom/xamoom-ios-sdk/wiki/Installing#dependencies).

## Installation with [CocoaPods](https://cocoapods.org/)

Add in your podfile

    pod 'xamoom-ios-sdk', '~> 1.2.1'

Install pods via terminal

    pod install

# Usage

## Setup XMMEnduserApi

```objective-c
//set your api key
[[XMMEnduserApi sharedInstance] setApiKey:kApiKey];
```

## Make your first call

Grab a contentId from your [xamoom-system](https://xamoom.net/) (open a page and copy id from url) and make your first call like this:

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES
                                            completion:^(XMMResponseGetById *result){
                                              NSLog(@"finishedLoadDataById: %@", result.description);
                                            } error:^(XMMError *error) {
                                              NSLog(@"LoadDataById Error: %@", error.message);
                                            }
   ];
```

When your call is successful you will get a [`XMMResponseGetById`](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetById.html) object. 

## API Calls

### [contentWithContentId: includeStyle: includeMenu: withLanguage: full: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/contentWithContentId:includeStyle:includeMenu:withLanguage:full:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| contentId | The id of the content from xamoom backend |
| style | True or False for returning the style from xamoom backend as [XMMResponseStyle](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseStyle.html)
| menu | True or False for returning the menu from xamoom backend as Array of [XMMResponseMenuItem](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetSpotMapItem.html)
| language | The requested language of the content from xamoom backend
| full | True or false for returning “unsynced” data or not
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMReponseGetById](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetById.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] contentWithContentId:kContentId includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES
                                            completion:^(XMMResponseGetById *result){
                                              NSLog(@"finishedLoadDataById: %@", result.description);
                                            } error:^(XMMError *error) {
                                              NSLog(@"LoadDataById Error: %@", error.message);
                                            }
   ];
```

### [contentWithLocationIdentifier: includeStyle: includeMenu: withLanguage: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/contentWithLocationIdentifier:includeStyle:includeMenu:withLanguage:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| locationIdentifier | The locationidentifier (code saved on NFC or QR) of the marker from xamoom backend |
| style | True or False for returning the style from xamoom backend as [XMMResponseStyle](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseStyle.html)
| menu | True or False for returning the menu from xamoom backend as Array of [XMMResponseMenuItem](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetSpotMapItem.html)
| language | The requested language of the content from xamoom backend
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMResponseGetByLocationIdentifier](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetByLocationIdentifier.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:kLocationIdentifier includeStyle:YES includeMenu:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                     completion:^(XMMResponseGetByLocationIdentifier *result){
                                                       NSLog(@"finishedLoadDataByLocationIdentifier: %@", result.description);
                                                       self.outputTextView.text = result.description;
                                                     } error:^(XMMError *error) {
                                                       NSLog(@"LoadDataByLocationIdentifier Error: %@", error.message);
                                                     }];
```

### [contentWithLat: withLon: withLanguage: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/contentWithLat:withLon:withLanguage:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| lat | The latitude of a location |
| lon | The longitude of a location |
| language | The requested language of the content from xamoom backend |
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMResponseGetByLocation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetByLocation.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] contentWithLat:@"46.615" withLon:@"14.263" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                      completion:^(XMMResponseGetByLocation *result){
                                        NSLog(@"finishedLoadDataByLocation: %@", result.description);
                                      } error:^(XMMError *error) {
                                        NSLog(@"LoadDataByLocation Error: %@", error.message);
                                      }
   ];
```

### [spotMapWithMapTags: withLanguage: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/spotMapWithMapTags:withLanguage:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| mapTags | The tags of the wanted spots |
| language | The requested language of the content from xamoom backend |
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMResponseGetSpotMap](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseGetSpotMap.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] spotMapWithMapTags:@[@"Cars",@"Banks"] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                           completion:^(XMMResponseGetSpotMap *result) {
                                             NSLog(@"finishedGetSpotMap: %@", result.description);
                                           } error:^(XMMError *error) {
                                             NSLog(@"GetSpotMap Error: %@", error.message);
                                           }
   ];
```

### [contentListWithPageSize: withLanguage: withCursor: withTags: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/contentListWithPageSize:withLanguage:withCursor:withTags:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| pageSize | Number of items you will get returned |
| cursor | Cursor for paging |
| tags | Tags as an array |
| language | The requested language of the content from xamoom backend |
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMResponseContentList](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseContentList.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] contentListWithPageSize:5 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:@"null" withTags:@[@"artists"]
                                               completion:^(XMMResponseContentList *result){
                                                 NSLog(@"finishedGetContentList full: %@", result.description);
                                               } error:^(XMMError *error) {
                                                 NSLog(@"GetContentList Error: %@", error.message);
                                               }
   ];
```

### [closestSpotsWithLat: withLon: withRadius: withLimit: withLanguage: completion: error:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/closestSpotsWithLat:withLon:withRadius:withLimit:withLanguage:completion:error:)

#### Parameters
| parameter | description |
| --- | --- |
| lat | Latitude |
| lon | Longitude |
| radius | Radius in decimenter |
| limit | Limit of the results |
| language | The requested language of the content from xamoom backend |
| completionHandler	| CompletionHandler returns the result
| errorHandler | ErrorHandler returns an error if one occures

#### Response

The response is a [XMMResponseClosestSpot](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMResponseClosestSpot.html) object.

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] closestSpotsWithLat:46.615 withLon:14.263 withRadius:1000 withLimit:100 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                           completion:^(XMMResponseClosestSpot *result){
                                             NSLog(@"finishedLoadClosestSpots: %@", result.description);
                                           } error:^(XMMError *error) {
                                             NSLog(@"LoadClosestSpots Error: %@", error.message);
                                           }
   ];
```

### [geofenceAnalyticsMessageWithRequestedLanguage:withDeliveredLanguage:withSystemId:withSystemName:withContentId:withContentName: withSpotId: withSpotName:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/geofenceAnalyticsMessageWithRequestedLanguage:withDeliveredLanguage:withSystemId:withSystemName:withContentId:withContentName:withSpotId:withSpotName:)

Call this after a user interacts with a geofence (contentWithLat:andLon:...).

#### Parameters
| parameter | description |
| --- | --- |
| requestedLanguage | The language you requested from the xamoom system |
| deliveredLanguage | The language you got from the xamoom system |
| systemId | The systemId you got from the xamoom system |
| systemName | The systemName you got from the xamoom system |
| contentId | The contentId you got from the xamoom system |
| contentName | The contentName you got from the xamoom system |
| spotId | The spotId you got from the system |
| spotName | The spotName you got from the system |

#### Example 

```objective-c
//make your call
[[XMMEnduserApi sharedInstance] geofenceAnalyticsMessageWithRequestedLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                          withDeliveredLanguage:self.savedResponseContent.language
                                                                   withSystemId:self.savedResponseContent.systemId
                                                                 withSystemName:self.savedResponseContent.systemName
                                                                  withContentId:self.savedResponseContent.contentId
                                                                withContentName:self.savedResponseContent.contentName
                                                                     withSpotId:self.savedResponseContent.spotId
                                                                   withSpotName:self.savedResponseContent.spotName];
```

### [startQRCodeReaderFromViewController:didLoad:](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html#//api/name/startQRCodeReaderFromViewController:didLoad:)

Starts a QRCodeReader from a specific view. ([QRCodeReaderViewController](https://github.com/dlazaro66/QRCodeReaderView) code on Github)

#### Parameters
| parameter | description |
| --- | --- |
| requestedLanguage | The language you requested from the xamoom system |
| completionHandler	| CompletionHandler returns the result |

#### Example 

```objective-c
//set the cancelButtonTitle
[[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Cancel"];
//open QRCodeReaderViewController
[[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self didLoad:^(NSString *locationIdentifier, NSString *url) {
    NSLog(@"LocationIdentifier: %@ und url: %@", locationIdentifier, url);
}];
```

Every call is also on our documentation: [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html)

# XMMContentBlocks

xamoom has a lot of different contentBlocks. With XMMContentBlocks you have a easy way to display them.
How to use it is in our [Step by Step Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Step-by-Step:-New-App-with-xamoom-ios-sdk).

# Requirements

* ARC
* Minumum iOS Target: iOS 8
* [RestKit 0.24.1](https://github.com/RestKit/RestKit)
* [QRCodeReaderViewController 2.0.0](https://github.com/dlazaro66/QRCodeReaderView)
* [SMCalloutView](https://github.com/nfarina/calloutview)
* [SVGKit](https://github.com/SVGKit/SVGKit)
* [youtube-ios-player-helper](https://github.com/youtube/youtube-ios-player-helper)
* [SDWebImage](https://github.com/rs/SDWebImage)
