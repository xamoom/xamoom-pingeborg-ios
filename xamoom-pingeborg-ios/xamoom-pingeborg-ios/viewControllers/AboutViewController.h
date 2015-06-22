//
//  SettingsViewController.h
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import <UIKit/UIKit.h>
#import "ArtistDetailViewController.h"
#import "FeedItemCell.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface AboutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XMMEnduserApiDelegate, XMMContentBlocksDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property REMenu *fontSizeDropdownMenu;

@end
