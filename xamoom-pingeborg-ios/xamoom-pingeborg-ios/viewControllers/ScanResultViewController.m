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

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@property JGProgressHUD *hud;

@end

@implementation ScanResultViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //init and start progessHud
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  //setup
  [self setupTableView];
  [self setupTextSizeDropdown];
  [self setupContentBlocks];
  
  [self.hud showInView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
  [self setupAnalyticsWithName:[NSString stringWithFormat:@"Scan Result - %@", self.result.content.title]];
  [super viewDidAppear:animated];
  [self displayContentTitleAndImage];
  [self.contentBlocks displayContentBlocksByLocationIdentifierResult:self.result];
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];
  
  //reload tableViews, when the newest scanned artist is open (So the "discover" overlay disappears)
  if ([self.result.content.contentId isEqualToString: [[Globals sharedObject] savedArtistsAsArray].lastObject]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAllArtistLists" object:self];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

# pragma mark - Setup

- (void)setupTableView {
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
}

- (void)setupTextSizeDropdown {
  //dropdown menu
  REMenuItem *NormalFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Normal Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [self.contentBlocks updateFontSizeTo:NormalFontSize];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Big Font Size", nil)
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [self.contentBlocks updateFontSizeTo:BigFontSize];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Really Big Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [self.contentBlocks updateFontSizeTo:BiggerFontSize];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  
  //create changeFontSize button
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
  self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)setupContentBlocks {
  self.contentBlocks = [[XMMContentBlocks alloc] initWithLanguage:[XMMEnduserApi sharedInstance].systemLanguage withWidth:self.tableView.bounds.size.width];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
}

#pragma mark - NavbarDropdown

-(void)toggleFontSizeDropdownMenu {
  if (self.fontSizeDropdownMenu.isOpen)
    return [self.fontSizeDropdownMenu close];
  
  [self.fontSizeDropdownMenu showFromNavigationController:self.navigationController];
}

#pragma mark - XMMContentBlocks delegates

- (void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
  //open new artistDetailViewController when tap a contentBlock
  if ([(self.contentBlocks.itemsToDisplay)[indexPath.row] isKindOfClass:[ContentBlockTableViewCell class]]) {
    ContentBlockTableViewCell *cell = (self.contentBlocks.itemsToDisplay)[indexPath.row];
    
    ArtistDetailViewController *vc = [[ArtistDetailViewController alloc] init];
    [vc setContentId:cell.contentId];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.contentBlocks.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.hud dismiss];
  return (self.contentBlocks.itemsToDisplay)[indexPath.row];
}

#pragma mark - Custom Methods

- (void)displayContentTitleAndImage {
  //make text and imageblock for the title, exercpt and the display image
  
  XMMResponseContentBlockType0 *contentBlock0 = [[XMMResponseContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = @"title";
  contentBlock0.title = self.result.content.title;
  contentBlock0.text = self.result.content.descriptionOfContent;
  [self.contentBlocks displayContentBlock0:contentBlock0];
  
  if (self.result.content.imagePublicUrl != nil) {
    XMMResponseContentBlockType3 *contentBlock3 = [[XMMResponseContentBlockType3 alloc] init];
    contentBlock3.fileId = self.result.content.imagePublicUrl;
    [self.contentBlocks displayContentBlock3:contentBlock3];
  }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Analytics

- (void)setupAnalyticsWithName:(NSString*)screenName {
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[[GAIDictionaryBuilder createScreenView] set:screenName
                                                       forKey:kGAIScreenName] build]];
}


@end
