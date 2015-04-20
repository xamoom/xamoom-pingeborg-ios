//
//  SettingsViewController.h
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "Globals.h"
#import "FeedItemCell.h"
#import "ArtistDetailViewController.h"

@interface DiscoverViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, XMMEnderuserApiDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
