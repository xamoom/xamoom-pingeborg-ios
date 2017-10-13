![](https://storage.googleapis.com/xamoom-files/cb9dcdd940f44b53baf5c27f331c4079.png)

# xamoom-ios-sdk
With the XamoomSDK we created a simple SDK to let you create apps based on our system.

More informations about xamoom and how xamoom works? Visit our Github page [xamoom Github Wiki](https://github.com/xamoom/xamoom.github.io/wiki)

# Getting Started

* Read the ["Getting Started"](https://github.com/xamoom/xamoom-ios-sdk/wiki#getting-started) guide in the wiki
* Check out the [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/3.4.0/index.html)
* Check out our sample app: ["pingeborg App"](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

## Manual Installation
Download the XamoomSDK and add it to your project, build it and use the framework.

## Installation with [CocoaPods](https://cocoapods.org/)

Add in your podfile

    pod 'XamoomSDK', '~> 3.6.0'

Install pods via terminal

    pod install

# Usage

## Setup XMMEnduserApi

```objective-c
XMMEnduserApi *api = [[XMMEnduserApi alloc] initWithApiKey:@"your-api-key"];
```

## Make your first call

Grab a contentID from your [xamoom-system](https://xamoom.net/) (open a page and copy the ID from url) and make your first call like this:

```objective-c
//make your call
[self.api contentWithID:contentID completion:^(XMMContent \*content, NSError \*error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }

    NSLog(@"ContentWithID: %@", content.title);
  }];
```

Every call is also on our documentation: [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/3.1.0/html/Classes/XMMEnduserApi.html)

# iBeacons

xamoom offers support for iBeacons. We have a [small guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/iBeacons) to implement them in the [wiki](https://github.com/xamoom/xamoom-ios-sdk/wiki).

# XMMContentBlocks

xamoom has a lot of different contentBlocks. With XMMContentBlocks you have a easy way to display them.
How to use it is in our [Step by Step Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Step-by-Step-Guide).

# Push notifications

To use our Push Notifications please check our [Push Notification Documentation](https://github.com/xamoom/xamoom-ios-sdk/wiki/Push-Notifications).

# Offline

## Save & get entities Offline

You can save your entities offline and use them even if you are not connected
to the internet.

To save entities offline call its `saveOffline` method.
For example to save a content works like this:

```objective-c
[content saveOffline];

// with completionBlock for automatically downloaded files
// XMMContent & XMMSpot will download their files
[content saveOffline:^(NSString \*url, NSData \*data, NSError \*error) {
  NSLog(@"Downloaded file %@", url);
}];
```

To get offline saved entities use the `XMMEnduserApi` and set the offline property
to true:
```objective-c
enduserApi.offline = YES;
```
All `XMMEnduserApi` calls will now return you the offline saved entities.

# Requirements

* ARC
* Minimum iOS Target: iOS 8
