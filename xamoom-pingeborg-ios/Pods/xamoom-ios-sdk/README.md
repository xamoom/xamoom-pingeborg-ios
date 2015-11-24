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

    pod 'xamoom-ios-sdk', '~> 1.3.2'

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

## [API Calls]((https://github.com/xamoom/xamoom-ios-sdk/wiki/API-Calls))

Check out our [API Calls Wiki Page](https://github.com/xamoom/xamoom-ios-sdk/wiki/API-Calls).

Every call is also on our documentation: [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/docs/html/Classes/XMMEnduserApi.html)

# XMMContentBlocks

xamoom has a lot of different contentBlocks. With XMMContentBlocks you have a easy way to display them.
How to use it is in our [Step by Step Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Step-by-Step-Guide).

# Requirements

* ARC
* Minumum iOS Target: iOS 8
* [RestKit 0.24.1](https://github.com/RestKit/RestKit)
* [QRCodeReaderViewController 2.0.0](https://github.com/dlazaro66/QRCodeReaderView)
* [SMCalloutView](https://github.com/nfarina/calloutview)
* [SVGKit](https://github.com/SVGKit/SVGKit)
* [youtube-ios-player-helper](https://github.com/youtube/youtube-ios-player-helper)
* [SDWebImage](https://github.com/rs/SDWebImage)
