//
//  FeedTableViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "FeedTableViewController.h"


static int const feedItemMargin = 10;
static NSString *cellIdentifier = @"FeedItemCell";

@interface FeedTableViewController ()

@property NSMutableArray *itemsToDisplay;
@property NSMutableArray *imagesToDisplay;
@property NSString *contentListCursor;
@property bool hasMore;
@property bool isApiCallingBlocked;

@end

@implementation FeedTableViewController

@synthesize itemsToDisplay;
@synthesize imagesToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    itemsToDisplay = [[NSMutableArray alloc] init];
    imagesToDisplay = [[NSMutableArray alloc] init];
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentListFromApi:@"6588702901927936" withLanguage:@"de" withPageSize:5 withCursor:@"null"];
    
    //set NavigationController delegate
    NavigationViewController* navController = (NavigationViewController*) self.parentViewController.parentViewController;
    navController.delegate = self;
    
    //navbarDropdown
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,(self.view.frame.size.width/1.5),32)];
    [button addTarget:navController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"pingeborg Klagenfurt" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((iv.frame.size.width/2) - 3.5, iv.frame.size.height-3.5, 7, 3.5)];
    UIImage *angleDownImage = [UIImage imageNamed:@"angleDown"];
    [imageView setImage:angleDownImage];
    
    [iv addSubview:button];
    [iv addSubview:imageView];
    self.parentViewController.navigationItem.titleView = iv;

    //setting up refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:25/255.0f green:198/255.0f blue:255/255.0f alpha:1.0f];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(pullToRefresh)
                  forControlEvents:UIControlEventValueChanged];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isPingeborgSystemChanged"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO
                       forKey:@"isPingeborgSystemChanged"];
        [userDefaults synchronize];
    }
}

#pragma mark - XMMEnduserApi delegates

-(void)didLoadContentList:(XMMResponseContentList *)result {    
    self.contentListCursor = result.cursor;
    
    if ([result.hasMore isEqualToString:@"True"])
        self.hasMore = YES;
    else
        self.hasMore = NO;
    
    for (XMMResponseContent *contentItem in result.items) {
        FeedItemData *data = [[FeedItemData alloc] init];
        data.content = contentItem;
        data.contentId = contentItem.contentId;
        if(contentItem.imagePublicUrl != nil) {
            [self downloadImageWithURL:contentItem.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    data.image = image;
                    [self reloadData];
                }
            }];
        }
        
        [itemsToDisplay addObject:data];
    }
    self.isApiCallingBlocked = NO;
    [self.tableView reloadData];
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

#pragma mark - NavbarDropdown Delegation
-(void)didChangeSystem {
    NSInteger location = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
    
    if ([self.parentViewController.navigationItem.titleView.subviews[0] isKindOfClass:[UIButton class]]) {
        UIButton *button = self.parentViewController.navigationItem.titleView.subviews[0];
        
        switch (location) {
            case 0:
                [button setTitle:@"pingeborg Klagenfurt" forState:UIControlStateNormal];
                break;
            case 1:
                [button setTitle:@"pingeborg Salzburg" forState:UIControlStateNormal];
                break;
            case 2:
                [button setTitle:@"pingeborg Villach" forState:UIControlStateNormal];
                break;
            case 3:
                [button setTitle:@"pingeborg Vorarlberg" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
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
    FeedItemData *data;
    
    //checking for array out of bounds caused by pull to refresh
    if (indexPath.row > itemsToDisplay.count) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
        return [nib objectAtIndex:0];
    }
    else {
        data = (FeedItemData*)[itemsToDisplay objectAtIndex:indexPath.row];
    }
    
    FeedItemCell *cell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    else {
        cell.feedItemImage.image = nil;
    }
    
    //styling the label
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:data.content.title
                                                                   attributes:@{ NSParagraphStyleAttributeName : style}];
    //set the title
    cell.feedItemTitle.attributedText = attrText;
    
    if (data.image != nil) {
        cell.feedItemImage.image = data.image;
    }
    
    //load more contents
    if (indexPath.row == [self.itemsToDisplay count] - 1) {
        if (self.hasMore && !self.isApiCallingBlocked) {
            self.isApiCallingBlocked = YES;
            [[XMMEnduserApi sharedInstance] setDelegate:self];
            [[XMMEnduserApi sharedInstance] getContentListFromApi:@"6588702901927936" withLanguage:@"de" withPageSize:5 withCursor:self.contentListCursor];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
    FeedItemData *data = (FeedItemData*)[itemsToDisplay objectAtIndex:indexPath.row];
    artistDetailViewController.contentId = data.contentId;
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.tableView.frame.size.width/2.6323987539) + feedItemMargin;
}

- (void)pullToRefresh {
    if(!self.isApiCallingBlocked) {
        itemsToDisplay = nil;
        itemsToDisplay = [[NSMutableArray alloc] init];
        [[XMMEnduserApi sharedInstance] setDelegate:self];
        [[XMMEnduserApi sharedInstance] getContentListFromApi:@"6588702901927936" withLanguage:@"de" withPageSize:5 withCursor:@"null"];
        self.isApiCallingBlocked = YES;
    }
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, hh:mm"];
        NSString *title = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
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
