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

XMMResponseGetByLocationIdentifier *_result;
BOOL isFirstTime;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstTime = YES;
    
    for (UITabBarItem *item in self.tabBar.items) {
        [item setImageInsets:UIEdgeInsetsMake(4,0,-4,0)];
    }
    
    [self.tabBar.subviews[3] setHidden:YES];
    
    
    /*
    UIImage *buttonImage = [UIImage imageNamed:@"QR"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"QR"] forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
    
     */
    
    UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleButton addTarget:self action:@selector(tappedMiddleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonImage = [UIImage imageNamed:@"QR"];
    [middleButton setImage:buttonImage forState:UIControlStateNormal];
    [middleButton setTintColor:[UIColor whiteColor]];
    
    CGRect frame;
    frame.size.height = 49;
    frame.size.width = [self.tabBar.subviews[3] size].width;
    frame.origin.x = (self.tabBar.frame.size.width/4) * 3 + ([self.tabBar.subviews[3] size].width / 2 ) - ([self.tabBar.subviews[3] size].width / 2 ) ;
    frame.origin.y = (self.tabBar.frame.size.height/2) - 24.5;
    [middleButton setFrame:frame];
    
    [self.tabBar addSubview:middleButton];
}

-(void)tappedMiddleButton:(id)sender {
    NSLog(@"Hellyeah");
    
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
    [[XMMEnduserApi sharedInstance] startQRCodeReader:self withAPIRequest:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    isFirstTime = YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    /*
    if (item.tag == 2) {
        [[XMMEnduserApi sharedInstance] setDelegate:self];
        [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
        [[XMMEnduserApi sharedInstance] startQRCodeReader:self withAPIRequest:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    }
    */
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
