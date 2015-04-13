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
    
    //tableview settings
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
    itemsToDisplay = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentByIdFull:self.contentId includeStyle:@"False" includeMenu:@"False" withLanguage:@"de" full:@"False"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - XMMEnduser Delegate
- (void)didLoadDataById:(XMMResponseGetById *)result {
    [self displayContentBlocks:result];
}

# pragma mark - ContentBlock Methods
- (void)displayContentBlocks:(XMMResponseGetById *)result {
    NSInteger contentBlockType;
    for (XMMResponseContentBlock *contentBlock in result.content.contentBlocks) {
        contentBlockType = [contentBlock.contentBlockType integerValue];
        
        switch (contentBlockType) {
            case 0:
            {
                XMMResponseContentBlockType0 *contentBlock0 = (XMMResponseContentBlockType0*)contentBlock;
                [self displayContentBlock0:contentBlock0];
                break;
            }
            case 1:
            {
                XMMResponseContentBlockType1 *contentBlock1 = (XMMResponseContentBlockType1*)contentBlock;
                [self displayContentBlock1:contentBlock1];
                break;
            }
            case 2:
            {
                XMMResponseContentBlockType2 *contentBlock2 = (XMMResponseContentBlockType2*)contentBlock;
                [self displayContentBlock2:contentBlock2];
                break;
            }
            case 3:
            {
                XMMResponseContentBlockType3 *contentBlock3 = (XMMResponseContentBlockType3*)contentBlock;
                [self displayContentBlock3:contentBlock3];
                break;
            }
            case 4:
            {
                XMMResponseContentBlockType4 *contentBlock4 = (XMMResponseContentBlockType4*)contentBlock;
                [self displayContentBlock4:contentBlock4];
                break;
            }
            case 5:
            {
                XMMResponseContentBlockType5 *contentBlock5 = (XMMResponseContentBlockType5*)contentBlock;
                [self displayContentBlock5:contentBlock5];
                break;
            }
            case 6:
            {
                NSLog(@"Hellyeah! ContentBlock6");
                break;
            }
            case 7:
            {
                NSLog(@"Hellyeah! ContentBlock7");
                break;
            }
            case 8:
            {
                NSLog(@"Hellyeah! ContentBlock8");
                break;
            }
            case 9:
            {
                NSLog(@"Hellyeah! ContentBlock9");
                break;
            }
            default:
                break;
        }
    }
    [self.tableView reloadData];
}

- (void)displayContentBlock0:(XMMResponseContentBlockType0 *)contentBlock {
    NSError *err = nil;
    static NSString *cellIdentifier = @"TextBlockTableViewCell";
    
    TextBlockTableViewCell *cell = (TextBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //set title
    cell.titleLabel.text = contentBlock.title;
    
    //set content (html content transform to textview text)
    contentBlock.text = [contentBlock.text stringByAppendingString:@"<style>html{font-family: 'HelveticaNeue-Light';font-size: 14px;}</style>"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData: [contentBlock.text dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                        NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                 documentAttributes: nil
                                                                              error: &err];
    cell.contentLabel.attributedText = attributedString;
    
    if(err)
        NSLog(@"Unable to parse label text: %@", err);
    
    //resizes cellview
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect cellSize = cell.frame;
    cellSize.size.height = [cell.contentLabel sizeThatFits:cell.contentLabel.frame.size].height + [cell.titleLabel sizeThatFits:cell.titleLabel.frame.size].height + 24;
    //cell.frame = cellSize;
    
    //add to array
    [itemsToDisplay addObject: cell];
}

- (void)displayContentBlock1:(XMMResponseContentBlockType1 *)contentBlock {
    static NSString *cellIdentifier = @"AudioBlockTableViewCell";
    
    AudioBlockTableViewCell *cell = (AudioBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AudioBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //set title
    cell.fileId = contentBlock.fileId;
    cell.titleLabel.text = contentBlock.title;
    cell.artistLabel.text = contentBlock.artist;
    
    //resizes cellview
    //cell.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect cellSize = cell.frame;
    cellSize.size.height = [cell.artistLabel sizeThatFits:cell.artistLabel.frame.size].height + [cell.titleLabel sizeThatFits:cell.titleLabel.frame.size].height;
    
    if (cellSize.size.height < cell.controlView.frame.size.height)
        cellSize.size.height = cell.controlView.frame.size.height + 14;
    
    //cell.frame = cellSize;
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock2:(XMMResponseContentBlockType2 *)contentBlock {
    static NSString *cellIdentifier = @"YoutubeBlockTableViewCell";
    
    YoutubeBlockTableViewCell *cell = (YoutubeBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YoutubeBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    cell.youtubeVideoUrl = contentBlock.youtubeUrl;
    
    //get the videoId from the string
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:cell.youtubeVideoUrl options:0 range:NSMakeRange(0,cell.youtubeVideoUrl.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        NSString* youtubeVideoId = [cell.youtubeVideoUrl substringWithRange:result.range];
        //load video inside playerView
        [cell.playerView loadWithVideoId:youtubeVideoId];
    }

    [itemsToDisplay addObject:cell];
}

NSLayoutConstraint *aspectRatio;

- (void)displayContentBlock3:(XMMResponseContentBlockType3 *)contentBlock {
    static NSString *cellIdentifier = @"ImageBlockTableViewCell";
    
    ImageBlockTableViewCell *cell = (ImageBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    
    if(contentBlock.fileId != nil) {
        [self downloadImageWithURL:contentBlock.fileId completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded && image) {
                float imageRatio = image.size.width/image.size.height;

                //smaller images will be displayed normal size and centered
                if (image.size.width < cell.image.frame.size.width) {
                    [cell.image setContentMode:UIViewContentModeCenter];
                    [cell.imageHeightConstraint setConstant:image.size.height];
                }
                else {
                    //bigger images will be resized und displayed full-width
                    [cell.imageHeightConstraint setConstant:(cell.imageWidthConstraint.constant / imageRatio)];
                }
                
                [cell.image setImage:image];
                [self.tableView reloadData];
            }
            
        }];
    }
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock4:(XMMResponseContentBlockType4 *)contentBlock {
    static NSString *cellIdentifier = @"LinkBlockTableViewCell";
    
    LinkBlockTableViewCell *cell = (LinkBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LinkBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    [cell.linkButton setTitle:contentBlock.text forState:UIControlStateNormal];
    cell.linkUrl = contentBlock.linkUrl;
    cell.linkType = contentBlock.linkType;
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock5:(XMMResponseContentBlockType5 *)contentBlock {
    static NSString *cellIdentifier = @"EbookBlockTableViewCell";
    
    EbookBlockTableViewCell *cell = (EbookBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EbookBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    cell.artistLabel.text = contentBlock.artist;
    cell.downloadUrl = contentBlock.fileId;
    
    [itemsToDisplay addObject:cell];
}

- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSURL *realUrl = [[NSURL alloc]initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
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
    [[itemsToDisplay objectAtIndex:indexPath.row] layoutIfNeeded];
    return [itemsToDisplay objectAtIndex:indexPath.row];
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
