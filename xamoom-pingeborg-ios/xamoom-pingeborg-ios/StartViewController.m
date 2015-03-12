//
//  StartViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "StartViewController.h"
#import "RSSItemViewController.h"

static int const rssFeedMargin = 10;


@interface StartViewController () 

@end

@implementation StartViewController

int y;
XMMRSSEntry *_rssEntry;
NSMutableArray *itemsToDisplay;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentViewController.navigationItem.title = @"Home";
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
    
    itemsToDisplay = [[NSMutableArray alloc]init];
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

                                   [itemsToDisplay addObject:mainView];
                                   
                                   
                                   NSArray *sortedArray;
                                   sortedArray = [itemsToDisplay sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                                       NSDate *first = [[(RSSFeedItemView*)a rssEntry] pubDate];
                                       NSDate *second = [[(RSSFeedItemView*)b rssEntry] pubDate];
                                       return [second compare:first];
                                   }];
                                   
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

- (void)viewDidAppear:(BOOL)animated {
    self.parentViewController.navigationItem.title = @"Home";
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [[segue identifier] isEqualToString:@"showRSSItem"] ) {
        RSSItemViewController *vc = [segue destinationViewController];
        [vc setRssEntry:_rssEntry];
    }
}


@end
