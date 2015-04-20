//
//  ArtistDetailViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ArtistDetailViewController.h"

@interface ArtistDetailViewController ()

@property XMMContentBlocks *contentBlocks;

@end

@implementation ArtistDetailViewController

@synthesize contentBlocks;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview settings
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
     contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView];
    
    // Do any additional setup after loading the view.
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentByIdFull:self.contentId includeStyle:@"False" includeMenu:@"False" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage full:@"False"];
    
    //reload data notification
    NSString *notificationName = @"reloadArtistDetails";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadData)
     name:notificationName
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pingeborgSystemChanged)
                                                 name:@"PingeborgSystemChanged"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self.tableView reloadData];
}

# pragma mark - XMMEnduser Delegate
- (void)didLoadDataById:(XMMResponseGetById *)result {
    [self displayContentTitleAndImage:result];
    [contentBlocks displayContentBlocksById:result byLocationIdentifier:nil];
}

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

- (void)pingeborgSystemChanged {
}

@end
