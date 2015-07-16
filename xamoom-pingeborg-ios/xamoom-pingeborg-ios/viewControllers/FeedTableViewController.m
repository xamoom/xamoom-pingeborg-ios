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

@interface FeedTableViewController ()

@property UIBarButtonItem *qrButtonItem;
@property UIImage *placeholderImage;
@property UIRefreshControl *refreshControl;
@property JGProgressHUD *hud;

@property NSMutableArray *itemsToDisplay;
@property NSMutableDictionary *imagesToDisplay;
@property NSString *contentListCursor;
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

  self.parentViewController.navigationItem.title = NSLocalizedString(@"pingeb.org Carinthia", nil);
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_filled"]];

  self.placeholderImage = [UIImage imageNamed:@"placeholder"];
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.imagesToDisplay = [[NSMutableDictionary alloc] init];
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  [self setupTableView];
  [self refreshControl];
  [self addNotifications];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //load artists, if there are none
  if (self.itemsToDisplay.count <= 0) {
    [self loadArtists];
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
  self.feedTableView.rowHeight = UITableViewAutomaticDimension;
  self.feedTableView.estimatedRowHeight = 150.0;
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

- (void)addNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadData)
                                               name:@"updateAllArtistLists"
                                             object:nil];
}

#pragma mark - XMMEnduserApi

- (void)loadArtists {
  //loading hud in view
  [self.hud showInView:self.view];
  [[XMMEnduserApi sharedInstance] contentListWithPageSize:kPageSize withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:@"null" withTags:@[@"artists"]
                                               completion:^(XMMResponseContentList *result) {
                                                 [self displayContentList:result];
                                                 [self.hud dismiss];
                                               } error:^(XMMError *error) {
                                                 NSLog(@"Error: %@", error.message);
                                               }];
}

- (void)displayContentList:(XMMResponseContentList *)result {
  self.contentListCursor = result.cursor;
  
  //check if first startup
  if ([[Globals sharedObject] isFirstStart]) {
    [self firstStartup:result];
  }
  
  //save if there are more items available over api
  self.hasMore = result.hasMore;
  
  for (XMMResponseContent *contentItem in result.items) {
    //download image
    [XMMImageUtility imageWithUrl:contentItem.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
      if (image != nil) {
        [self.imagesToDisplay setValue:image forKey:contentItem.contentId];
      } else if (svgImage != nil) {
        [self.imagesToDisplay setValue:svgImage forKey:contentItem.contentId];
      } else {
        [self.imagesToDisplay setValue:self.placeholderImage forKey:contentItem.contentId];
      }
      
      [self.feedTableView reloadData];
    }];
    
    //add contentItem
    [self.itemsToDisplay addObject:contentItem];
  }
  
  self.isApiCallingBlocked = NO;
  [self reloadData];
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
  static NSString *feedItemCellIdentifier = @"FeedItemCell";
  
  FeedItemCell *cell = (FeedItemCell *)[self.feedTableView dequeueReusableCellWithIdentifier:feedItemCellIdentifier];
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
    cell = nib[0];
  }
  
  [cell.loadingIndicator startAnimating];
  
  //set defaults to images
  cell.feedItemImage.image = nil;
  [cell.feedItemImage.subviews  makeObjectsPerformSelector: @selector(removeFromSuperview)];
  
  cell.loadingIndicator.hidden = NO;
  
  //save for out of range
  if (indexPath.row >= [self.itemsToDisplay count]) {
    return cell;
  }
  XMMResponseContent *contentItem = (self.itemsToDisplay)[indexPath.row];
  
  //set title
  cell.feedItemTitle.text = contentItem.title;
  
  //set image & grayscale if needed
  if((self.imagesToDisplay)[contentItem.contentId] != nil) {
    UIImage *image = (self.imagesToDisplay)[contentItem.contentId];
    float imageRatio = image.size.width / image.size.height;
    [cell.imageHeightConstraint setConstant:(self.view.frame.size.width / imageRatio)];
    
    if ([(self.imagesToDisplay)[contentItem.contentId] isKindOfClass:[SVGKImage class]]) {
      SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:(self.imagesToDisplay)[contentItem.contentId]];
      [svgImageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / imageRatio))];
      [cell.feedItemImage addSubview:svgImageView];
    } else if (![[[Globals sharedObject] savedArtits] containsString:contentItem.contentId]) {
      cell.feedItemImage.image = [XMMImageUtility convertImageToGrayScale:image];
      cell.feedItemOverlayImage.backgroundColor = [UIColor whiteColor];
    } else {
      cell.feedItemImage.image = image;
      cell.feedItemOverlayImage.backgroundColor = [UIColor clearColor];
    }
    
    [cell.loadingIndicator stopAnimating];
  }
  
  //overlay image for the first cell "discoverable"
  if (contentItem == self.itemsToDisplay.firstObject && ![[[Globals sharedObject] savedArtits] containsString:contentItem.contentId]) {
    cell.feedItemOverlayImage.image = [UIImage imageNamed:@"discoverable"];
  } else {
    cell.feedItemOverlayImage.image = nil;
  }
  
  //load more contents
  if (indexPath.row == (self.itemsToDisplay.count - 1)) {
    [self loadMoreContent];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
  XMMResponseContent *data = (XMMResponseContent*)(self.itemsToDisplay)[indexPath.row];
  artistDetailViewController.contentId = data.contentId;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

- (void)pullToRefresh {
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Reload" andLabel:@"Artist View reloaded." andValue:nil];
  
  [self.hud showInView:self.view];
  if(!self.isApiCallingBlocked) {
    //delete all items in arrays
    self.itemsToDisplay = [[NSMutableArray alloc] init];
    self.imagesToDisplay = [[NSMutableDictionary alloc] init];
    
    //api call
    [[XMMEnduserApi sharedInstance] contentListWithPageSize:kPageSize withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:@"null" withTags:@[@"artists"]
                                                 completion:^(XMMResponseContentList *result) {
                                                   [self displayContentList:result];
                                                   [self.hud dismiss];
                                                 } error:^(XMMError *error) {
                                                   NSLog(@"Error: %@", error.message);
                                                 }];
    self.isApiCallingBlocked = YES;
  }
}

- (void)reloadData {
  // Reload table data
  [self.feedTableView reloadData];
  
  // End the refreshing
  if (self.refreshControl) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, hh:mm"];
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Last update: %@", nil), [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    [self.refreshControl endRefreshing];
  }
}

- (void)loadMoreContent {
  if (self.hasMore && !self.isApiCallingBlocked) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Load More" andLabel:@"Artist List load more." andValue:nil];
    
    self.isApiCallingBlocked = YES;
    [[XMMEnduserApi sharedInstance] contentListWithPageSize:kPageSize withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withCursor:self.contentListCursor withTags:@[@"artists"]
                                                 completion:^(XMMResponseContentList *result) {
                                                   [self displayContentList:result];
                                                   self.feedTableView.tableFooterView = nil;
                                                 } error:^(XMMError *error) {
                                                   NSLog(@"Error: %@", error.message);
                                                 }];
    
    //add tablefooter as loading indicator to the feedTableView
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

# pragma mark - Instruction View / First Start

- (void)firstStartup:(XMMResponseContentList *)result {
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

- (void)addFreeDiscoveredArtists:(XMMResponseContentList *)result {
  //add artist 2-4 to discovered list
  int counter = 1;
  while (counter <= 3) {
    XMMResponseContent *contentItem = result.items[counter];
    [[Globals sharedObject] addDiscoveredArtist:contentItem.contentId];
    counter++;
  }
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}
*/

@end
