//
//  SettingsViewController.h
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "XMMContentBlocks.h"
#import "Globals.h"
#import "ArtistDetailViewController.h"
#import "FeedItemCell.h"

@interface AboutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XMMEnderuserApiDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
