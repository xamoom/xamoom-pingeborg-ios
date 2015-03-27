//
//  StartViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "StartViewController.h"
#import "RSSItemViewController.h"
#import "NavigationViewController.h"

static int const rssFeedMargin = 10;

@interface StartViewController ()

@end

@implementation StartViewController

int y;
XMMRSSEntry *_rssEntry;
NSMutableArray *itemsToDisplay;


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.parentViewController.navigationItem.title = @"Home";
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [self pingeborgSystemFeedUrl];
    [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
    
    //set dropDownMenuDelegate
    NavigationViewController* navController = (NavigationViewController*) self.parentViewController.parentViewController;
    navController.delegate = self;
    
    UIView *iv = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,32)];
    [iv setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,32)];
    label.text = @"Hellyeah";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0,200,32)];
    [button addTarget:navController action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:label];
    [iv addSubview:button];
    self.parentViewController.navigationItem.titleView = iv;
    
    itemsToDisplay = [[NSMutableArray alloc]init];
    
    //self.parentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didLoadRSS:(NSMutableArray *)result {
    for (XMMRSSEntry* entry in result) {
        //create RSSFeedItemView from .xib
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"RSSFeedItemView" owner:self options:nil];
        RSSFeedItemView *mainView = [subviewArray objectAtIndex:0];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: entry.titleImageUrl ]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   
                                   //init mainView
                                   mainView.rssEntry = entry;
                                   mainView.title.text = entry.title;
                                   mainView.image.image = [UIImage imageWithData:data];
                                   [mainView setDelegate:self];
                                   
                                   //styling the label
                                   NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                                   style.alignment = NSTextAlignmentJustified;
                                   style.firstLineHeadIndent = 10.0f;
                                   style.headIndent = 10.0f;
                                   style.tailIndent = -10.0f;
                                   style.lineBreakMode = NSLineBreakByTruncatingTail;
                                   NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:entry.title attributes:@{ NSParagraphStyleAttributeName : style}];
                                   mainView.title.attributedText = attrText;
                                   
                                   [itemsToDisplay addObject:mainView];
                                   
                                   NSArray *sortedArray;
                                   sortedArray = [itemsToDisplay sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                                       NSDate *first = [[(RSSFeedItemView*)a rssEntry] pubDate];
                                       NSDate *second = [[(RSSFeedItemView*)b rssEntry] pubDate];
                                       return [second compare:first];
                                   }];
                                   
                                   //delete all views
                                   for (UIView *subView in self.scrollView.subviews) {
                                       [subView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                                   }
                                   
                                   y = 0;
                                   for (RSSFeedItemView *item in sortedArray) {
                                       item.frame = CGRectMake(0, y, self.view.frame.size.width, (self.view.frame.size.width * 0.3799));
                                       y += item.frame.size.height + rssFeedMargin;
                                       
                                       //add shadow to view
                                       CALayer *layer = item.layer;
                                       layer.shadowOffset = CGSizeMake(0, 1);
                                       layer.shadowColor = [[UIColor blackColor] CGColor];
                                       layer.shadowRadius = 2.5f;
                                       layer.shadowOpacity = 0.80f;
                                       layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
                                       
                                       [self.scrollView addSubview:item];
                                   }
                                   
                                   CGSize scrollViewSize = self.scrollView.contentSize;
                                   scrollViewSize.height = y + self.tabBarController.tabBar.frame.size.height -10;
                                   self.scrollView.contentSize = scrollViewSize;
                               }];
    }
}

- (void)touchedRSSFeedItem:(XMMRSSEntry *)rssEntry {
    _rssEntry = rssEntry;
    [self performSegueWithIdentifier:@"showRSSItem" sender:self];
}

-(void)didChangeSystem {
    //delete all views
    for (UIView *subView in self.scrollView.subviews) {
        [subView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    }
    
    itemsToDisplay = nil;
    itemsToDisplay = [[NSMutableArray alloc] init];
    
    [self pingeborgSystemFeedUrl];
    [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
    
    NSInteger location = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
    UILabel *label = self.parentViewController.navigationItem.titleView.subviews[0];
    
    switch (location) {
        case 0:
            label.text = @"Klagenfurt";
            break;
        case 1:
            label.text = @"Salzburg";
            break;
        case 2:
            label.text = @"Villach";
            break;
        case 3:
            label.text = @"Vorarlberg";
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.parentViewController.navigationItem.title = @"Home";
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isPingeborgSystemChanged"]) {
        //delete all views
        for (UIView *subView in self.scrollView.subviews) {
            [subView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        }
        
        itemsToDisplay = nil;
        itemsToDisplay = [[NSMutableArray alloc] init];
        
        [self pingeborgSystemFeedUrl];
        [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO
                       forKey:@"isPingeborgSystemChanged"];
        [userDefaults synchronize];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [[segue identifier] isEqualToString:@"showRSSItem"] ) {
        RSSItemViewController *vc = [segue destinationViewController];
        [vc setRssEntry:_rssEntry];
    }
}

-(void)pingeborgSystemFeedUrl {
    NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:@"location"];
    switch (row) {
        case 0:
            [XMMEnduserApi sharedInstance].rssBaseUrl = @"http://pingeb.org/category/artists/feed/";
            break;
        case 1:
            [XMMEnduserApi sharedInstance].rssBaseUrl = @"http://salzburg.pingeb.org/category/artists/feed/";
            break;
        case 2:
            [XMMEnduserApi sharedInstance].rssBaseUrl = @"http://villach.pingeb.org/category/artists/feed/";
            break;
        case 3:
            [XMMEnduserApi sharedInstance].rssBaseUrl = @"http://vorarlberg.pingeb.org/category/artists/feed/";
            break;
        default:
            break;
    }
}


@end
