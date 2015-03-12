//
//  RSSItemViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "RSSItemViewController.h"

@interface RSSItemViewController () <UIWebViewDelegate>

@end

@implementation RSSItemViewController

NSString *cssString;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"styles" ofType:@"css"];
    NSData *loadedData = [NSData dataWithContentsOfFile:cssPath];
    if (loadedData) {
        cssString = [[NSString alloc] initWithData:loadedData encoding:NSUTF8StringEncoding];
    }
    
    [self.webViewForContent setDelegate:self];
    self.labelForTitle.text = self.rssEntry.title;
    
    self.rssEntry.content = [NSString stringWithFormat:@"%@ <br /> %@", cssString, self.rssEntry.content];
    [self.webViewForContent loadHTMLString:self.rssEntry.content baseURL:nil];
    
    //add shadow to view
    CALayer *layer = self.labelForTitle.layer;
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.20f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@", self.rssEntry.content);
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
