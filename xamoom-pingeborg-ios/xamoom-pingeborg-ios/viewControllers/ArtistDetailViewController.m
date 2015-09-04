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

#import "ArtistDetailViewController.h"

@interface ArtistDetailViewController () <XMMContentBlocksDelegate>

@property JGProgressHUD *hud;
@property REMenu *fontSizeDropdownMenu;

@property XMMContentById *savedResult;
@property XMMContentBlocks *contentBlocks;

@end

@implementation ArtistDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //analytics
  [[Analytics sharedObject] setScreenName:@"Artist Detail"];
  
  self.navigationItem.title = NSLocalizedString(@"pingeb.org", nil);
  
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
  
  //setup
  [self setupTableView];
  [self setupTextSizeDropdown];
  [self setupContentBlocks];
  [self downloadContent];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  //stop all sounds (audioBlock and soundCloudBlock)
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];

  //reload artistList, when you discovered a new one
  if ([self.contentId isEqualToString:[[Globals sharedObject] savedArtistsAsArray].lastObject]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAllArtistLists" object:self];
  }
}

#pragma mark - Setup

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
                                                                [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Normal Font Size" andValue:nil];
                                                                [self.contentBlocks updateFontSizeTo:NormalFontSize];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Big Font Size", nil)
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Big Font Size" andValue:nil];
                                                             [self.contentBlocks updateFontSizeTo:BigFontSize];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Really Big Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Really Big Font Size" andValue:nil];
                                                                [self.contentBlocks updateFontSizeTo:BiggerFontSize];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  self.fontSizeDropdownMenu.textColor = [UIColor whiteColor];
  
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

- (void)downloadContent {
  [self.hud showInView:self.view];

  NSString* savedArtists = [[Globals sharedObject] savedArtits];
  if ([savedArtists containsString:self.contentId]) {
    [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:@"" full:YES
                                              completion:^(XMMContentById *result) {
                                                [self showDataWithContentId:result];
                                              } error:^(XMMError *error) {
                                              }];
  } else {
    [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:@"" full:NO
                                              completion:^(XMMContentById *result) {
                                                [self showDataWithContentId:result];
                                              } error:^(XMMError *error) {
                                              }];
  }
}

#pragma mark - NavbarDropdown

- (void)toggleFontSizeDropdownMenu {
  if (self.fontSizeDropdownMenu.isOpen)
    return [self.fontSizeDropdownMenu close];
  
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"FontSizeMenu" andValue:nil];
  [self.fontSizeDropdownMenu showFromNavigationController:self.navigationController];
}

#pragma mark - XMMContentBlock Delegate

- (void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
}

# pragma mark - XMMEnduser Display ContentBlocks

- (void)showDataWithContentId:(XMMContentById *)result {
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Show content" andLabel:result.content.contentId andValue:nil];
  
  self.savedResult = result;
  [self.contentBlocks displayContentBlocksWithIdResult:result];
  [self.hud dismiss];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if ([(self.contentBlocks.itemsToDisplay)[indexPath.row] isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = (self.contentBlocks.itemsToDisplay)[indexPath.row];
    
    ArtistDetailViewController *vc = [[ArtistDetailViewController alloc] init];
    [[Globals sharedObject] addDiscoveredArtist:cell.contentId];
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
  return self.contentBlocks.itemsToDisplay[indexPath.row];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 NSLog(@"prepareForSegue");
 UIViewController *vc = [segue destinationViewController];
 }
 */

@end
