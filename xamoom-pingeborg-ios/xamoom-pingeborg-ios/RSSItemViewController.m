//
//  RSSItemViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "RSSItemViewController.h"

@interface RSSItemViewController ()

@end

@implementation RSSItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelForTitle.text = self.rssEntry.title;
    [self.webViewForContent loadHTMLString:self.rssEntry.content baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
