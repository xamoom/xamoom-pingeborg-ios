//
//  ArtistDetailViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ArtistDetailViewController.h"

@interface ArtistDetailViewController () <XMMContentBlocksDelegate>

@property JGProgressHUD *hud;
@property XMMResponseGetById *savedResult;
@property XMMContentBlocks *contentBlocks;
@property REMenu *fontSizeDropdownMenu;

@end

@implementation ArtistDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //tableview settings
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  self.contentBlocks = [[XMMContentBlocks alloc] init];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
  self.contentBlocks.language = @"de";
  self.contentBlocks.systemId = [Globals sharedObject].globalSystemId;
  NSString* savedArtists = [Globals savedArtits];
  
  // Do any additional setup after loading the view.
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
  [self.hud showInView:self.view];
  
  if ([savedArtists containsString:self.contentId]) {
    [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:YES];
  } else {
    [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:NO];
  }
  
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
  
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
  
  self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];
}

#pragma mark - NavbarDropdown

-(void)toggleFontSizeDropdownMenu {
  if (self.fontSizeDropdownMenu.isOpen)
    return [self.fontSizeDropdownMenu close];
  
  [self.fontSizeDropdownMenu showFromNavigationController:self.navigationController];
}

#pragma mark - XMMContentBlock Delegate

- (void)reloadTableViewForContentBlocks {
  [self.tableView reloadData];
}

# pragma mark - XMMEnduser Delegate

- (void)didLoadDataWithContentId:(XMMResponseGetById *)result {
  self.savedResult = result;
  [self displayContentOnTableView:self.savedResult];
  [self.hud dismiss];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
  return self.contentBlocks.itemsToDisplay[indexPath.row];
}

#pragma mark - Custom Methods

- (void)displayContentOnTableView:(XMMResponseGetById *)result {
  [self displayContentTitleAndImage:result];
  [self.contentBlocks displayContentBlocksById:result byLocationIdentifier:nil withScreenWidth:self.tableView.bounds.size.width];
}

- (void)displayContentTitleAndImage:(XMMResponseGetById *)result {
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
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 NSLog(@"prepareForSegue");
 UIViewController *vc = [segue destinationViewController];
 }
 */

@end
