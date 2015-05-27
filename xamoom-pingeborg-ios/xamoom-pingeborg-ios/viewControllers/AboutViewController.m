//
//  SettingsViewController.m
//
//
//  Created by Raphael Seher on 19.03.15.
//
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
  
  [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"info_filled"]];
  
  //setting up tableView
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  //setting up XMMContentBlocks
  self.contentBlocks = [[XMMContentBlocks alloc] initWithSystemId:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withWidth:self.view.frame.size.width];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
  
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
  
  //dropdown menu
  REMenuItem *NormalFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Normal Font Size"
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [self.contentBlocks updateFontSizeTo:NormalFontSize];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Big Font Size"
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [self.contentBlocks updateFontSizeTo:BigFontSize];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:@"Really Big Font Size"
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [self.contentBlocks updateFontSizeTo:BiggerFontSize];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  
  //create change font size button in navbar
  self.buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
  self.parentViewController.navigationItem.rightBarButtonItem = self.buttonItem;

}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = self.buttonItem;
  
  //load items if there are none
  if ([self.contentBlocks.itemsToDisplay count] == 0) {
    [self.hud showInView:self.view];
    [XMMEnduserApi sharedInstance].delegate = self;
    [[XMMEnduserApi sharedInstance] contentWithContentId:[Globals sharedObject].aboutPageId includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES];
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

#pragma mark - XMMEnduserApi delegates

- (void)didLoadDataWithContentId:(XMMResponseGetById *)result {
  [self displayContentTitleAndImage:result];
  [self.contentBlocks displayContentBlocksByIdResult:result];
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

- (void)displayContentTitleAndImage:(XMMResponseGetById *)result {
  //make text and image for the title, exercpt and the display image

  XMMResponseContentBlockType0 *contentBlock0 = [[XMMResponseContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = @"title";
  contentBlock0.title = result.content.title;
  contentBlock0.text = result.content.descriptionOfContent;
  [self.contentBlocks displayContentBlock0:contentBlock0];
  
  if (result.content.imagePublicUrl != nil) {
    XMMResponseContentBlockType3 *contentBlock3 = [[XMMResponseContentBlockType3 alloc] init];
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
