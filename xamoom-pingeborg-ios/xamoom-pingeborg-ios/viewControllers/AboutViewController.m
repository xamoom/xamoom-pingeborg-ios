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

  [self setupTableView];
  [self setupContentBlocks];
  [self setupTextSizeDropdown];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = self.buttonItem;
  
  //load items if there are none
  if ([self.contentBlocks.itemsToDisplay count] == 0) {
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
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
}

- (void)setupContentBlocks {
  //setting up XMMContentBlocks
  self.contentBlocks = [[XMMContentBlocks alloc] initWithLanguage:[XMMEnduserApi sharedInstance].systemLanguage withWidth:self.view.frame.size.width];
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

- (void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
}

#pragma mark - XMMEnduserApi delegates

- (void)showDataWithContentId:(XMMContentById *)result {
  [self.contentBlocks displayContentBlocksWithIdResult:result];
  [self.hud dismiss];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.contentBlocks.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return (self.contentBlocks.itemsToDisplay)[indexPath.row];
}

#pragma mark - Custom Methods

- (void)displayContentTitleAndImage:(XMMContentById *)result {
  //make text and image for the title, exercpt and the display image
  
  XMMContentBlockType0 *contentBlock0 = [[XMMContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = 0;
  contentBlock0.title = result.content.title;
  contentBlock0.text = result.content.descriptionOfContent;
  [self.contentBlocks displayContentBlock0:contentBlock0 addTitleFontOffset:0];
  
  if (result.content.imagePublicUrl != nil) {
    XMMContentBlockType3 *contentBlock3 = [[XMMContentBlockType3 alloc] init];
    contentBlock3.fileId = result.content.imagePublicUrl;
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

@end
