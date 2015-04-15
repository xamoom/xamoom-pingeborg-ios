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
    
    //reload data notification
    NSString *notificationName = @"reloadArtistDetails";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadData)
     name:notificationName
     object:nil];
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
                XMMResponseContentBlockType6 *contentBlock6 = (XMMResponseContentBlockType6*)contentBlock;
                [self displayContentBlock6:contentBlock6];
                break;
            }
            case 7:
            {
                XMMResponseContentBlockType7 *contentBlock7 = (XMMResponseContentBlockType7*)contentBlock;
                [self displayContentBlock7:contentBlock7];
                break;
            }
            case 8:
            {
                XMMResponseContentBlockType8 *contentBlock8 = (XMMResponseContentBlockType8*)contentBlock;
                [self displayContentBlock8:contentBlock8];
                break;
            }
            case 9:
            {
                XMMResponseContentBlockType9 *contentBlock9 = (XMMResponseContentBlockType9*)contentBlock;
                [self displayContentBlock9:contentBlock9];
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
                    [cell.imageHeightConstraint setConstant:(cell.image.frame.size.width / imageRatio)];
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
    cell.linkTextLabel.text = contentBlock.text;
    cell.linkUrl = contentBlock.linkUrl;
    cell.linkType = contentBlock.linkType;
        
    [cell changeStyleAccordingToLinkType];
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

- (void)displayContentBlock6:(XMMResponseContentBlockType6 *)contentBlock {
    static NSString *cellIdentifier = @"ContentBlockTableViewCell";
    
    ContentBlockTableViewCell *cell = (ContentBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContentBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.contentId = contentBlock.contentId;
    [cell getContent];
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock7:(XMMResponseContentBlockType7 *)contentBlock {
    static NSString *cellIdentifier = @"SoundcloudBlockTableViewCell";
    
    SoundcloudBlockTableViewCell *cell = (SoundcloudBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SoundcloudBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //disable scrolling and bouncing
    [cell.webView.scrollView setScrollEnabled:NO];
    [cell.webView.scrollView setBounces:NO];
    
    //set title
    cell.titleLabel.text = contentBlock.title;
    
    //get soundcloud code from file
    NSString *soundcloudJs;
    NSString *soundcloudJsPath = [[NSBundle mainBundle] pathForResource:@"soundcloud" ofType:@"js"];
    NSData *loadedData = [NSData dataWithContentsOfFile:soundcloudJsPath];
    if (loadedData) {
        soundcloudJs = [[NSString alloc] initWithData:loadedData encoding:NSUTF8StringEncoding];
    }
    
    //replace url and height from soundcloudJs
    NSString *soundcloudUrl = contentBlock.soundcloudUrl;
    soundcloudJs = [soundcloudJs stringByReplacingOccurrencesOfString:@"##url##"
                                                           withString:soundcloudUrl];
    
    soundcloudJs = [soundcloudJs stringByReplacingOccurrencesOfString:@"##height##"
                                                           withString:[NSString stringWithFormat:@"%f", cell.webView.frame.size.height]];

    //display soundcloud in webview
    [cell.webView loadHTMLString:soundcloudJs baseURL:nil];
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock8:(XMMResponseContentBlockType8 *)contentBlock {
    static NSString *cellIdentifier = @"DownloadBlockTableViewCell";
    
    DownloadBlockTableViewCell *cell = (DownloadBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DownloadBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    cell.contentTextLabel.text = contentBlock.text;
    cell.fileId = contentBlock.fileId;
    cell.downloadType = contentBlock.downloadType;
    
    [itemsToDisplay addObject:cell];
}

- (void)displayContentBlock9:(XMMResponseContentBlockType9 *)contentBlock {
    static NSString *cellIdentifier = @"SpotMapBlockTableViewCell";
    
    SpotMapBlockTableViewCell *cell = (SpotMapBlockTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SpotMapBlockTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = contentBlock.title;
    cell.spotMapTags = contentBlock.spotMapTag;
    [cell getSpotMap];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[itemsToDisplay objectAtIndex:indexPath.row] isKindOfClass:[ContentBlockTableViewCell class]]) {
        ContentBlockTableViewCell *cell = [itemsToDisplay objectAtIndex:indexPath.row];
        NSLog(@"check hellyeah: %@", cell.contentId);
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArtistDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailViewController"];
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
    return [itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [itemsToDisplay objectAtIndex:indexPath.row];
}

- (void)reloadData {
    [self.tableView reloadData];
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
