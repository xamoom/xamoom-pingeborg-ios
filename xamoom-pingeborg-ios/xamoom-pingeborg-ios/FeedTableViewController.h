//
//  FeedTableViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "NavigationViewController.h"
#import "XMMEnduserApi.h"
#import "FeedItemCell.h"
#import "ArtistDetailViewController.h"

@interface FeedTableViewController : UITableViewController <XMMEnderuserApiDelegate, DropDownMenuDelegate>

@end
