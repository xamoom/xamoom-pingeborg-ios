//
//  FeedTableViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationViewController.h"
#import "FeedItemCell.h"
#import "ArtistDetailViewController.h"
#import "ScanResultViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <SVGKit.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

extern int const kPageSize;

@interface FeedTableViewController : UIViewController <XMMEnduserApiDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (weak, nonatomic) IBOutlet UIView *instructionView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *instructionViewTapGestureRecognizer;

@end
