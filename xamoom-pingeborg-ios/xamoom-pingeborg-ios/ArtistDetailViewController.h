//
//  ArtistDetailViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "Globals.h"
#import "XMMContentBlocks.h"
#import "REMenu.h"
#import <JGProgressHUD/JGProgressHUD.h>

@class XMMContentBlocks;
@protocol XMMContentBlocksDelegate;

@interface ArtistDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, XMMEnderuserApiDelegate, XMMContentBlocksDelegate>

@property NSString *contentId;

@end
