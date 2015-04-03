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
@property NSString *contentListCursor;
@property bool hasMore;

@end

@implementation FeedTableViewController

@synthesize itemsToDisplay;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    itemsToDisplay = [[NSMutableArray alloc] init];
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
        [itemsToDisplay addObject:contentItem];
        
    }
    [self.tableView reloadData];
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
    XMMResponseContent *content = (XMMResponseContent*)[itemsToDisplay objectAtIndex:indexPath.row];
    
    FeedItemCell *cell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //styling the label
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:content.title
                                                                   attributes:@{ NSParagraphStyleAttributeName : style}];
    //set the title
    cell.feedItemTitle.attributedText = attrText;
    
    //set the image+
    cell.feedItemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:content.imagePublicUrl]]];
    
    //load more contents
    if (indexPath.row == [self.itemsToDisplay count] - 1) {
        if (self.hasMore) {
            [[XMMEnduserApi sharedInstance] getContentListFromApi:@"6588702901927936" withLanguage:@"de" withPageSize:5 withCursor:self.contentListCursor];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TableRow %ld clicked", (long)indexPath.row);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.tableView.frame.size.width/2.6323987539) + feedItemMargin;
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
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
