//
//  StartViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "StartViewController.h"
#import "RSSItemViewController.h"

@interface StartViewController () 

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation StartViewController

int y;
XMMRSSEntry *_rssEntry;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parentViewController.navigationItem.title = @"Home";

    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
    
    //set view height to 1000
    CGRect frame = self.view.frame;
    frame.size.height = 1000;
    [self.view setFrame:frame];
    //set scrollViewHeight to 2000
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 2000.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didLoadRSS:(NSMutableArray *)result {
    float scrollViewHeight = 0;
    
    for (XMMRSSEntry* entry in result) {
        //create RSSFeedItemView from .xib
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"RSSFeedItemView" owner:self options:nil];
        RSSFeedItemView *mainView = [subviewArray objectAtIndex:0];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: entry.titleImageUrl ]];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSLog(@"Data: %@", [UIImage imageWithData:data]);
                                   
                                   mainView.rssEntry = entry;
                                   mainView.title.text = entry.title;
                                   mainView.image.image = [UIImage imageWithData:data];
                                   mainView.frame = CGRectMake(0, y, mainView.frame.size.width, mainView.frame.size.height);
                                   
                                   [mainView setDelegate:self];
                                   
                                   [self.scrollView addSubview:mainView];
                                   
                                   y += 210;
                                   //scrollViewHeight += y;
                               }];
        
        //mainView.image.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: entry.titleImageUrl ]]];
        
    }
    
}

- (void)touchedRSSFeedItem:(XMMRSSEntry *)rssEntry {
    _rssEntry = rssEntry;
    [self performSegueWithIdentifier:@"showRSSItem" sender:self];
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
