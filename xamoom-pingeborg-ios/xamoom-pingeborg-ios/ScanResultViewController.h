//
//  ScanResultViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"

@interface ScanResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) XMMResponseGetByLocationIdentifier *result;
@property XMMContentBlocks *contentBlocks;

@end
