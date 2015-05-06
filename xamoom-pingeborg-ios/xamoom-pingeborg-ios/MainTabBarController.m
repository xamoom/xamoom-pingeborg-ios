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

  self.delegate = self;
  
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  isFirstTime = YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  //instead of switching view the qr code scanner will be opened
  if(viewController == [tabBarController.viewControllers objectAtIndex:3]){
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
    [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    return NO;
  }else{
    return YES;
  }
}

#pragma mark - QRCodeReader Delegate Methods

-(void)didScanQR:(NSString *)result {
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:@"0ana0" includeStyle:@"False" includeMenu:@"False" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)apiResult {
  [Globals addDiscoveredArtist:apiResult.content.contentId];
  result = apiResult;
  [self performSegueWithIdentifier:@"showScanResult" sender:self];
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
