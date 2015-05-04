//
//  ScanResultViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController

@synthesize result;
@synthesize contentBlocks;

JGProgressHUD *hud;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //tableview settings
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  contentBlocks = [[XMMContentBlocks alloc] init];
  contentBlocks.delegate = self;
  
  //dropdown menu
  REMenuItem *NormalFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Normal Font Size"
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [contentBlocks updateFontSizeOnTextTo:NormalFontSize];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Big Font Size"
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [contentBlocks updateFontSizeOnTextTo:BigFontSize];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Really Big Font Size"
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [contentBlocks updateFontSizeOnTextTo:BiggerFontSize];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
  
  self.navigationItem.rightBarButtonItem = buttonItem;
  
  hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  [hud showInView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self displayContentTitleAndImage];
  [contentBlocks displayContentBlocksById:nil byLocationIdentifier:result];
  [hud dismiss];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if ([[contentBlocks.itemsToDisplay objectAtIndex:indexPath.row] isKindOfClass:[ContentBlockTableViewCell class]]) {
    ContentBlockTableViewCell *cell = [contentBlocks.itemsToDisplay objectAtIndex:indexPath.row];
    
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
  return [contentBlocks.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [contentBlocks.itemsToDisplay objectAtIndex:indexPath.row];
}

#pragma mark - Custom Methods

- (void)displayContentTitleAndImage {
  XMMResponseContentBlockType0 *contentBlock0 = [[XMMResponseContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = @"title";
  contentBlock0.title = result.content.title;
  contentBlock0.text = result.content.descriptionOfContent;
  [contentBlocks displayContentBlock0:contentBlock0];
  
  if (result.content.imagePublicUrl != nil) {
    XMMResponseContentBlockType3 *contentBlock3 = [[XMMResponseContentBlockType3 alloc] init];
    contentBlock3.fileId = result.content.imagePublicUrl;
    [contentBlocks displayContentBlock3:contentBlock3];
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
