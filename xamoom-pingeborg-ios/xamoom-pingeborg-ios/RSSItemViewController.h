//
//  RSSItemViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMRSSEntry.h"

@interface RSSItemViewController : UIViewController

@property XMMRSSEntry* rssEntry;
@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webViewForContent;

@end