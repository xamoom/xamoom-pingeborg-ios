//
//  StartViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController () 

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation StartViewController

int y;
NSMutableArray *images;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[XMMEnduserApi sharedInstance]setDelegate:self];
    [[XMMEnduserApi sharedInstance] getContentFromRSSFeed];
    
    //set view height to 1000
    CGRect frame = self.view.frame;
    frame.size.height = 1000;
    [self.view setFrame:frame];
    //set scrollViewHeight to 2000
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 2000.0);
    
    images = [[NSMutableArray alloc] init];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2015/02/Rubinowitz_Tex_C-Hertha-Hurnaus_845_321--845x321.jpg"];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2015/02/AnLaKa_845_321.jpg"];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2015/01/KlemmGertraud_845_321px-845x321.jpg"];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2015/01/motschiunig_845_321.jpg"];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2015/01/auer1_kk-845-321.jpg"];
    [images addObject:@"http://pingeb.org/wp-content/uploads/2014/12/tijana-845-321-845x321.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)randomImage {
    //load images
    int x = arc4random() % 5;
    
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: [images objectAtIndex:x] ]]];
    
    return myImage;
}

- (void)didLoadRSS:(NSMutableArray *)result {
    float scrollViewHeight = 0;
    
    for (XMMRSSEntry* entry in result) {
        //create RSSFeedItemView from .xib
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"RSSFeedItemView" owner:self options:nil];
        RSSFeedItemView *mainView = [subviewArray objectAtIndex:0];
        mainView.title.text = entry.title;
        mainView.image.image = [self randomImage];
        mainView.frame = CGRectMake(0, y, mainView.frame.size.width, mainView.frame.size.height);
        [mainView setDelegate:self];
        
        [self.scrollView addSubview:mainView];
        
        y += 210;
        scrollViewHeight += y;
    }
    
}

- (void)touchedRSSFeedItem {
    [self performSegueWithIdentifier:@"showRSSItem" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [[segue identifier] isEqualToString:@"showRSSItem"] ) {
        
        //HERE
    }
}


@end
