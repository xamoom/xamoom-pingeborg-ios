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

@class XMMContentBlocks;

@interface ArtistDetailViewController : UITableViewController <XMMEnderuserApiDelegate>

@property NSString *contentId;
@property XMMContentBlocks *contentBlocks;

@end
