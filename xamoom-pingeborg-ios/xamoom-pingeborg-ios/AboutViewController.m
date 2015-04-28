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

@end

@implementation AboutViewController

@synthesize contentBlocks;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  //setting up tableView
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  contentBlocks = [[XMMContentBlocks alloc] init];
  contentBlocks.delegate = self;
  
  [XMMEnduserApi sharedInstance].delegate = self;
  [[XMMEnduserApi sharedInstance] getContentByIdFull:[Globals sharedObject].aboutPageId includeStyle:@"false" includeMenu:@"false" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:@"True"];
}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - XMMContentBlocks delegates

- (void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
}

#pragma mark - XMMEnduserApi delegates

- (void)didLoadDataById:(XMMResponseGetById *)result {
  [self displayContentTitleAndImage:result];
  [contentBlocks displayContentBlocksById:result byLocationIdentifier:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [contentBlocks.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  //load more contents
  return [contentBlocks.itemsToDisplay objectAtIndex:indexPath.row];
}

#pragma mark - Custom Methods

- (void)displayContentTitleAndImage:(XMMResponseGetById *)result {
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
