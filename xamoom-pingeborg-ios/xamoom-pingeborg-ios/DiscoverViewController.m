//
//  SettingsViewController.m
//  
//
//  Created by Raphael Seher on 19.03.15.
//
//

#import "DiscoverViewController.h"

static const NSInteger pageSize = 7;

@interface DiscoverViewController ()

@property NSMutableArray *itemsToDisplay;
@property NSString *contentListCursor;

@property BOOL hasMore;
@property BOOL isApiCallingBlocked;

@end

@implementation DiscoverViewController

@synthesize itemsToDisplay;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //setting up tableView
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    itemsToDisplay = [[NSMutableArray alloc] init];
    [XMMEnduserApi sharedInstance].delegate = self;
    [[XMMEnduserApi sharedInstance] getContentListFromApi:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:pageSize withCursor:@"null"];

}

-(void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMMEnduserApi delegates

-(void)didLoadContentList:(XMMResponseContentList *)result {
    NSString *savedArtists = [Globals savedArtits];
    self.contentListCursor = result.cursor;
    
    if ([result.hasMore isEqualToString:@"True"])
        self.hasMore = YES;
    else
        self.hasMore = NO;
    
    for (XMMResponseContent *contentItem in result.items) {
        FeedItemCell *cell;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.contentId = contentItem.contentId;
        
        //styling the label
        NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentJustified;
        style.firstLineHeadIndent = 10.0f;
        style.headIndent = 10.0f;
        style.tailIndent = -10.0f;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:contentItem.title
                                                                       attributes:@{ NSParagraphStyleAttributeName : style}];
        //set the title
        cell.feedItemTitle.attributedText = attrText;
        
        if(contentItem.imagePublicUrl != nil) {
            [self downloadImageWithURL:contentItem.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    float imageRatio = image.size.width/image.size.height;
                    [cell.imageHeightConstraint setConstant:(cell.frame.size.width / imageRatio)];
                    if (![savedArtists containsString:contentItem.contentId]) {
                        image = [self convertImageToGrayScale:image];
                    }
                    [cell.feedItemImage setImage:image];
                    [self.tableView reloadData];
                }
            }];
        }
        [itemsToDisplay addObject:cell];
    }
    
    self.isApiCallingBlocked = NO;
    [self.tableView reloadData];
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
    //load more contents
    if (indexPath.row == [self.itemsToDisplay count] - 1) {
        if (self.hasMore && !self.isApiCallingBlocked) {
            self.isApiCallingBlocked = YES;
            [[XMMEnduserApi sharedInstance] setDelegate:self];
            [[XMMEnduserApi sharedInstance] getContentListFromApi:[Globals sharedObject].globalSystemId withLanguage:[XMMEnduserApi sharedInstance].systemLanguage withPageSize:pageSize withCursor:self.contentListCursor];
        }
    }
    
    return [itemsToDisplay objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
    FeedItemCell *data = (FeedItemCell*)[itemsToDisplay objectAtIndex:indexPath.row];
    artistDetailViewController.contentId = data.contentId;
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

#pragma mark - Image Methods

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
