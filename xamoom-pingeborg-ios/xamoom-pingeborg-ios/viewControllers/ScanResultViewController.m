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
  
  //analytics
  [[Analytics sharedObject] setScreenName:@"Scan Result"];
  
  //init and start progessHud
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  //setup
  [self setupTableView];
  [self setupTextSizeDropdown];
  [self setupContentBlocks];
  
  [self.hud showInView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Show content" andLabel:self.result.content.contentId andValue:nil];
  
  self.contentBlocks.content = self.result.content;
  [self.hud dismiss];
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
  self.tableView.dataSource = self.contentBlocks;
  self.tableView.delegate = self.contentBlocks;
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
  self.contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView
                                                          language:[XMMEnduserApi sharedInstance].systemLanguage];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
}

#pragma mark - NavbarDropdown

- (void)toggleFontSizeDropdownMenu {
  if (self.fontSizeDropdownMenu.isOpen)
    return [self.fontSizeDropdownMenu close];
  
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"FontSizeMenu" andValue:nil];
  [self.fontSizeDropdownMenu showFromNavigationController:self.navigationController];
}

#pragma mark - XMMContentBlocks delegates

- (void)didClickContentBlock:(NSString *)contentId {
  ArtistDetailViewController *vc = [[ArtistDetailViewController alloc] init];
  [vc setContentId:contentId];
  [self.navigationController pushViewController:vc animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
