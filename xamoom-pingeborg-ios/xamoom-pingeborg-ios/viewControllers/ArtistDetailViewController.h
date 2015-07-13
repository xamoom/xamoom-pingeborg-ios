//
//  ArtistDetailViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"  
#import <JGProgressHUD/JGProgressHUD.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface ArtistDetailViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property NSString *contentId;

@end
