//
//  ArtistDetailViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ArtistDetailViewController.h"

@interface ArtistDetailViewController ()

@property NSMutableArray *itemsToDisplay;

@end

@implementation ArtistDetailViewController

@synthesize itemsToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemsToDisplay = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentByIdFull:self.contentId includeStyle:@"False" includeMenu:@"False" withLanguage:@"de" full:@"False"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didLoadDataById:(XMMResponseGetById *)result {
    [self displayContentBlocks:result];
}

- (void)displayContentBlocks:(XMMResponseGetById *)result {
    NSInteger contentBlockType;
    for (XMMResponseContentBlock *contentBlock in result.content.contentBlocks) {
        contentBlockType = [contentBlock.contentBlockType integerValue];
        
        switch (contentBlockType) {
            case 0:
            {
                XMMResponseContentBlockType0 *contentBlock0 = (XMMResponseContentBlockType0*)contentBlock;
                [itemsToDisplay addObject:contentBlock0];
                break;
            }
            case 1:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 2:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 3:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 4:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 5:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 6:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 7:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 8:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            case 9:
            {
                NSLog(@"Hellyeah!");
                break;
            }
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

- (void)displayContentBlock1:(XMMResponseContentBlockType0 *)contentBlock {
    NSError *err = nil;
    
    /*
    label.attributedText = [[NSAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                 documentAttributes: nil
                                                              error: &err];
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
     */
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XMMResponseContentBlockType0 *contentBlock = (XMMResponseContentBlockType0*)[itemsToDisplay objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"TextBlockTableViewCell";
    TextBlockTableViewCell *cell = (TextBlockTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    else {
        //cell.feedItemImage.image = nil;
        //cell.feedItemTitle = nil;
    }
    
    NSError *err = nil;
    contentBlock.text = [contentBlock.text stringByAppendingString:@"<style>html{font-family: 'HelveticaNeue-Light';font-size: 14px;}</style>"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [contentBlock.text dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                        NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                 documentAttributes: nil
                                                                              error: &err];
    
    cell.contentTextView.attributedText = attributedString;
    
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 700;
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
