//
//  ScanResultViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface ScanResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, XMMContentBlocksDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XMMResponseGetByLocationIdentifier *result;
@property XMMContentBlocks *contentBlocks;
@property REMenu *fontSizeDropdownMenu;

@end
