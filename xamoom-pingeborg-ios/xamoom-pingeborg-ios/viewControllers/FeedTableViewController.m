//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import "FeedTableViewController.h"

int const kPageSize = 7;
NSString * const kFeedItemCellIdentifier = @"FeedItemCell";

@interface FeedTableViewController ()

@property UIBarButtonItem *qrButtonItem;
@property UIRefreshControl *refreshControl;
@property JGProgressHUD *hud;
@property CBCentralManager *bluetoothManager;
@property NSMutableArray *itemsToDisplay;
@property NSString *contentListCursor;
@property CLBeacon *lastBeacon;
@property bool hasMore;
@property bool isApiCallingBlocked;

@end

@implementation FeedTableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //do analytics
  [[Analytics sharedObject] setScreenName:@"Artist List"];
  [[Analytics sharedObject] sendEventWithCategorie:@"App" andAction:@"Started" andLabel:@"pingeb.org app started." andValue:nil];
  
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_filled"]];
  
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  [self setupTableView];
  [self setupRefreshControl];
  [self detectBluetooth];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  self.parentViewController.navigationItem.title = NSLocalizedString(@"pingeb.org", nil);
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //load artists, if there are none
  if (self.itemsToDisplay.count <= 0) {
    [self.hud showInView:self.view];
    [self downloadContent];
  } else {
    [self.feedTableView reloadData];
  }
}


- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self closeInstructionScreen];
}

#pragma mark - Setup

- (void)setupTableView {
  //setting up tableView
  [self.feedTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.feedTableView.rowHeight = 180.0f;
}

- (void)setupRefreshControl {
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [Globals sharedObject].pingeborgLinkColor;
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(pullToRefresh)
                forControlEvents:UIControlEventValueChanged];
  [self.feedTableView addSubview:self.refreshControl];
}

- (void)displayContentList:(NSArray *)contents {
  //check if first startup
  if ([[Globals sharedObject] isFirstStart]) {
    [self firstStartup:contents];
  }
  
  [self.itemsToDisplay addObjectsFromArray:contents];
  
  self.isApiCallingBlocked = NO;
  [self reloadData];
}

- (void)openArtist:(XMMContent *)content {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ArtistDetailViewController *artistDetailViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
  
  artistDetailViewController.contentId = content.ID;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

# pragma mark - XMMEnduserApi

- (void)downloadContent {
  [[XMMEnduserApi sharedInstance] contentsWithTags:@[@"artists"]
                                          pageSize:kPageSize
                                            cursor:self.contentListCursor
                                              sort:XMMContentSortOptionsNameDesc
                                        completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
                                          self.contentListCursor = cursor;
                                          self.hasMore = hasMore;
                                          [self displayContentList:contents];
                                          [self.hud dismiss];
                                        }];
}

# pragma mark - Pull to refresh

- (void)pullToRefresh {
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Reload" andLabel:@"Artist View reloaded." andValue:nil];
  
  [self.hud showInView:self.view];
  if(!self.isApiCallingBlocked) {
    //delete all items in arrays
    [self.itemsToDisplay removeAllObjects];
    self.contentListCursor = nil;
    [self downloadContent];
    self.isApiCallingBlocked = YES;
  }
}

- (void)reloadData {
  // Reload table data
  [self.feedTableView reloadData];
  
  // End the refreshing
  if (self.refreshControl) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, HH:mm"];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Last update: %@", nil), [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
  }
}

# pragma mark - Load more

- (void)loadMoreContent {
  if (self.hasMore && !self.isApiCallingBlocked) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Load More" andLabel:@"Artist List load more." andValue:nil];
    
    self.isApiCallingBlocked = YES;
    
    [self downloadContent];
    
    [self addTableViewLoadingFooter];
  }
}

- (void)addTableViewLoadingFooter {
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
  [headerView setBackgroundColor:[UIColor clearColor]];
  
  //create activity indicator
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  activityIndicator.center = CGPointMake((self.view.frame.size.width/2), 25);
  activityIndicator.hidesWhenStopped = NO;
  [headerView addSubview:activityIndicator];
  [activityIndicator startAnimating];
  
  self.feedTableView.tableFooterView = headerView;
}

#pragma mark - Bluetooth View

- (void)detectBluetooth {
  BOOL isDissmissed = [[NSUserDefaults standardUserDefaults] boolForKey:@"bluetooth-is-dismissed"];
  if (isDissmissed) {
    return;
  }
  
  if(!self.bluetoothManager) {
    // Put on main queue so we can call UIAlertView from delegate callbacks.
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: @NO};
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
  }
  [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  if (self.bluetoothManager.state == CBCentralManagerStatePoweredOff) {
    [self showBlueToothAlert];
  }
}
  
- (void)showBlueToothAlert {
  UIAlertController * alert = [UIAlertController
                               alertControllerWithTitle:NSLocalizedString(@"bluetooth alert title", nil)
                               message:NSLocalizedString(@"bluetooth alert message", nil)
                               preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* yesButton = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"bluetoothalert.action.ok", nil)
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action) {
                                [alert dismissViewControllerAnimated:true completion:nil];
                              }];
  
  UIAlertAction* noButton = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"bluetoothalert.action.dismiss", nil)
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bluetooth-is-dismissed"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               [alert dismissViewControllerAnimated:true completion:nil];
                             }];
  
  [alert addAction:yesButton];
  [alert addAction:noButton];
  
  [self presentViewController:alert animated:YES completion:nil];
}

# pragma mark - Instruction View / First Start

- (void)firstStartup:(NSArray *)result {
  [self addFreeDiscoveredArtists:result];
  [self displayInstructionScreen];
}

- (void)displayInstructionScreen {
  self.instructionView.hidden = NO;
}

- (IBAction)instructionViewTapGestureRecognizerTapped:(id)sender {
  [self closeInstructionScreen];
}

- (void)closeInstructionScreen {
  self.instructionView.hidden = YES;
}

- (void)addFreeDiscoveredArtists:(NSArray *)contents {
  //add artist 2-4 to discovered list
  int counter = 1;
  while (counter <= 3) {
    XMMContent *contentItem = contents[counter];
    [[Globals sharedObject] addDiscoveredArtist:contentItem.ID];
    counter++;
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FeedItemCell *cell = (FeedItemCell *)[self.feedTableView dequeueReusableCellWithIdentifier:kFeedItemCellIdentifier];
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
    cell = nib[0];
  }
  
  //save for out of range
  if (indexPath.row >= [self.itemsToDisplay count]) {
    return cell;
  }
  
  XMMContent *contentItem = (self.itemsToDisplay)[indexPath.row];
  Boolean isDiscoverable = (![[Globals sharedObject].savedArtits containsString:contentItem.ID] && indexPath.row == 0);
  [cell setupCellWithContent:contentItem
                discoverable:isDiscoverable];
  
  //load more contents
  if (indexPath.row == (self.itemsToDisplay.count - 1)) {
    [self loadMoreContent];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContent *data = (XMMContent*)(self.itemsToDisplay)[indexPath.row];
  self.parentViewController.navigationItem.title = nil;
  [self openArtist:data];
}

@end
