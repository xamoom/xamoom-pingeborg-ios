//
//  ViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 05/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize xmmApi;


- (void)viewDidLoad {
    [super viewDidLoad];
    xmmApi = [[XMMEnduserApi alloc] init];
    [xmmApi setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
