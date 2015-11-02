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

#import "AboutViewController.h"


@interface AboutViewController ()

@property XMMContentBlocks *contentBlocks;
@property JGProgressHUD *hud;
@property UIBarButtonItem *buttonItem;

@end

@implementation AboutViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //analytics
  [[Analytics sharedObject] setScreenName:@"About View"];
  
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"info_filled"]];
  
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];

  [self setupContentBlocks];
  [self setupTableView];
  [self setupTextSizeDropdown];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = self.buttonItem;
  
  //load items if there are none
  if ([self.contentBlocks.items count] == 0) {
    [self.hud showInView:self.view];
    [[XMMEnduserApi sharedInstance] contentWithContentId:[Globals sharedObject].aboutPageId includeStyle:NO includeMenu:NO withLanguage:@"" full:YES
                                              completion:^(XMMContentById *result) {
                                                [self showDataWithContentId:result];
                                              } error:^(XMMError *error) {
                                              }];
  }
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupTableView {
  //setting up tableView
  self.tableView.dataSource = self.contentBlocks;
  self.tableView.delegate = self.contentBlocks;
}

- (void)setupContentBlocks {
  //setting up XMMContentBlocks
  self.contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView
                                                          language:[XMMEnduserApi sharedInstance].systemLanguage];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
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
                                                                [self.tableView reloadData];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Big Font Size", nil)
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Big Font Size" andValue:nil];
                                                             [self.contentBlocks updateFontSizeTo:BigFontSize];
                                                             [self.tableView reloadData];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Really Big Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Really Big Font Size" andValue:nil];
                                                                [self.contentBlocks updateFontSizeTo:BiggerFontSize];
                                                                [self.tableView reloadData];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  self.fontSizeDropdownMenu.textColor = [UIColor whiteColor];
  
  //create changeFontSize button
  self.buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
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
  
}

#pragma mark - XMMEnduserApi delegates

- (void)showDataWithContentId:(XMMContentById *)result {
  self.contentBlocks.content = result.content;
  [self.hud dismiss];
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
