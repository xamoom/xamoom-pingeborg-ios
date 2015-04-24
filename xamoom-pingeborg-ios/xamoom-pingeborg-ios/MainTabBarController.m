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

XMMResponseGetByLocationIdentifier *result;
BOOL isFirstTime;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstTime = YES;
    
    for (UITabBarItem *item in self.tabBar.items) {
        [item setImageInsets:UIEdgeInsetsMake(4,0,-4,0)];
    }
    
    //hide original navbar scan-qr-button
    [self.tabBar.subviews[3] setHidden:YES];
    
    /*//navbar Dropdown Code
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
    
    //creating custom scan-qr-button
    UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleButton addTarget:self action:@selector(tappedMiddleButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"QR"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [middleButton setImage:buttonImage forState:UIControlStateNormal];
    middleButton.tintColor = [UIColor blueColor];
    
    CGRect frame;
    frame.size.height = 49;
    frame.size.width = [self.tabBar.subviews[3] size].width;
    frame.origin.x = (self.tabBar.frame.size.width/4) * 3 + ([self.tabBar.subviews[3] size].width / 2 ) - ([self.tabBar.subviews[3] size].width / 2 ) ;
    frame.origin.y = (self.tabBar.frame.size.height/2) - 24.5;
    [middleButton setFrame:frame];
    
    [self.tabBar addSubview:middleButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    isFirstTime = YES;
}

#pragma mark - User Interaction

-(void)tappedMiddleButton:(id)sender {
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
    [[XMMEnduserApi sharedInstance] startQRCodeReader:self withAPIRequest:YES withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
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

- (void)didLoadDataByLocationIdentifier:(XMMResponseGetByLocationIdentifier *)apiResult {
    NSLog(@"finishedLoadDataByLocationIdentifier: %@", apiResult);
    
    result = apiResult;
    if( isFirstTime ) {
        isFirstTime = NO;
        [Globals addDiscoveredArtist:apiResult.content.contentId];
        [self performSegueWithIdentifier:@"showScanResult" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [[segue identifier] isEqualToString:@"showScanResult"] ) {
        ScanResultViewController *srvc = [segue destinationViewController];
        [srvc setResult:result];
    }
}


@end
