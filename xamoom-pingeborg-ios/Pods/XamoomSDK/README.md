![](https://camo.githubusercontent.com/2fad8f28e3f8712be694e55345c77469af2d75ec/68747470733a2f2f78616d6f6f6d2e636f6d2f77702d696e68616c74652f75706c6f6164732f323031352f30322f6c6f676f2d626c61636b2d636c61696d312e706e67)
#xamoom-ios-sdk
With the XamoomSDK we created a simple SDK to let you create apps based on our system.

More informations about xamoom and how xamoom works? Visit our Github page [xamoom Github Wiki](https://github.com/xamoom/xamoom.github.io/wiki)

# Getting Started

* Read the ["Getting Started"](https://github.com/xamoom/xamoom-ios-sdk/wiki#getting-started) guide in the wiki
* Check out the [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/2.1.0/html/index.html)
* Check out our sample app: ["pingeborg App"](https://github.com/xamoom/xamoom-pingeborg-ios)

# Installation

## Manual Installation
Download the XamoomSDK and add it to your project, build it and use the framework.

## Installation with [CocoaPods](https://cocoapods.org/)

Add in your podfile

    pod 'XamoomSDK', '~> 2.1.0'

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
[self.api contentWithID:contentID completion:^(XMMContent *content, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
      return;
    }

    NSLog(@"ContentWithID: %@", content.title);
  }];
```

When your call is successful you will get a [`XMMContent`](http://xamoom.github.io/xamoom-ios-sdk/2.1.0/html/Classes/XMMContent.html) object.

## [API Calls]((https://github.com/xamoom/xamoom-ios-sdk/wiki/API-Calls))

Check out our [API Calls Wiki Page](https://github.com/xamoom/xamoom-ios-sdk/wiki/API-Calls).

Every call is also on our documentation: [XMMEnduserApi documentation](http://xamoom.github.io/xamoom-ios-sdk/2.1.0/html/Classes/XMMEnduserApi.html)

# iBeacons

xamoom offers support for iBeacons. We have a [small guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/iBeacons) to implement them in the [wiki](https://github.com/xamoom/xamoom-ios-sdk/wiki).

# XMMContentBlocks

xamoom has a lot of different contentBlocks. With XMMContentBlocks you have a easy way to display them.
How to use it is in our [Step by Step Guide](https://github.com/xamoom/xamoom-ios-sdk/wiki/Step-by-Step-Guide).

# Requirements

* ARC
* Minimum iOS Target: iOS 8
