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

@end

@implementation FeedTableViewController

@synthesize itemsToDisplay;

NSMutableArray *test;

- (void)viewDidLoad {
    [super viewDidLoad];

    itemsToDisplay = [[NSMutableArray alloc] init];
    [[XMMEnduserApi sharedInstance] setDelegate:self];

    //example for data
    test = [[NSMutableArray alloc] initWithObjects:
            @"82 | Bernd Sibitz | PANIK in St. Ruprecht und anderswo",
            @"82 | Bernd Sibitz | PANIK in St. Ruprecht und anderswo",
            @"82 | Bernd Sibitz | PANIK in St. Ruprecht und anderswo",
            @"82 | Bernd Sibitz | PANIK in St. Ruprecht und anderswo",
            @"82 | Bernd Sibitz | PANIK in St. Ruprecht und anderswo",
            nil];
    
    //set dropDownMenuDelegate
    NavigationViewController* navController = (NavigationViewController*) self.parentViewController.parentViewController;
    navController.delegate = self;
    
    //navbar dropdown
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,32)];
    [iv setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,32)];
    label.text = @"Hellyeah";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,200,32)];
    [button addTarget:navController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:label];
    [iv addSubview:button];
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
    self.parentViewController.navigationItem.title = @"Home";
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isPingeborgSystemChanged"]) {
        
        /*
         [self pingeborgSystemFeedUrl];
         [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
         
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         [userDefaults setBool:NO
         forKey:@"isPingeborgSystemChanged"];
         [userDefaults synchronize];
         */
    }
}

-(void)didChangeSystem {
    NSInteger location = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
    UILabel *label = self.parentViewController.navigationItem.titleView.subviews[0];
    
    switch (location) {
        case 0:
            label.text = @"pingeborg Klagenfurt";
            break;
        case 1:
            label.text = @"pingeborg Salzburg";
            break;
        case 2:
            label.text = @"pingeborg Villach";
            break;
        case 3:
            label.text = @"pingeborg Vorarlberg";
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [test count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedItemCell *cell = (FeedItemCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
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
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:[test objectAtIndex:indexPath.row]
                                                                   attributes:@{ NSParagraphStyleAttributeName : style}];
    cell.feedItemTitle.attributedText = attrText;
    
    //set the image
    //cell.feedItemImage.image = [UIImage imageNamed:@"car"];
    
    //set the contentId
    //cell.contentId = @"bla bla bla";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Hellyeah %ld", (long)indexPath.row);
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
