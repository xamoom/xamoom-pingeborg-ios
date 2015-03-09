//
//  MainTabBarControllerViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MainTabBarController.h"
#import "XMMEnduserApi.h"
#import "ScanResultViewController.h"

@interface MainTabBarController () <XMMEnderuserApiDelegate, QRCodeReaderDelegate>

@end

@implementation MainTabBarController

XMMEnduserApi *api;
XMMResponseGetByLocationIdentifier *_result;
BOOL isFirstTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    api = [[XMMEnduserApi alloc] init];
    [api setDelegate:self];
    isFirstTime = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    isFirstTime = YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag == 2) {
        [api startQRCodeReader:self withAPIRequest:YES withLanguage:api.systemLanguage];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Completion with result: %@", result);
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    NSLog(@"readerDidCancel");
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)result {
    NSLog(@"finishedLoadDataByLocationIdentifier: %@", result);
    _result = result;
    if( isFirstTime ) {
        [self performSegueWithIdentifier:@"showScanResult" sender:self];
        isFirstTime = NO;
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [[segue identifier] isEqualToString:@"showScanResult"] ) {
        ScanResultViewController *srvc = [segue destinationViewController];
        [srvc setResult:_result];
    }
}


@end
