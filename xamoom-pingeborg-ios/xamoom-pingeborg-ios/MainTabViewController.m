//
//  MainTabViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 06/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MainTabViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.parentViewController.navigationItem setTitle:@"Title"];
    //self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(myRightButton)];
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
