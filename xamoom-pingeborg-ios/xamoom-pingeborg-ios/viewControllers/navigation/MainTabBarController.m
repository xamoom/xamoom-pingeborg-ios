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

@interface MainTabBarController () <XMMEnduserApiDelegate, QRCodeReaderDelegate>

@property XMMResponseGetByLocationIdentifier *savedApiResult;

@end

@implementation MainTabBarController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.delegate = self;
  
  //center tabbar images
  for (UITabBarItem *item in self.tabBar.items) {
    [item setImageInsets:UIEdgeInsetsMake(4,0,-4,0)];
  }
  
  /*
  //navbar Dropdown Code
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
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  //instead of switching view the qr code scanner will be opened
  if(viewController == (tabBarController.viewControllers)[3]){
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:@"Abbrechen"];
    [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
    return NO;
  }else{
    return YES;
  }
}

#pragma mark - XMMEnduserApi Delegate Methods

-(void)didScanQR:(NSString *)result {
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:result includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)apiResult {
  [Globals addDiscoveredArtist:apiResult.content.contentId];
  self.savedApiResult = apiResult;
  
  //pingeborg scans will be opened in the app, others will be opened in safari
  if ([self.savedApiResult.systemId isEqualToString:[Globals sharedObject].globalSystemId])
    [self performSegueWithIdentifier:@"showScanResult" sender:self];
  else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.xm.gl/content/%@", self.savedApiResult.content.contentId]]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ( [[segue identifier] isEqualToString:@"showScanResult"] ) {
    ScanResultViewController *srvc = [segue destinationViewController];
    srvc.result = self.savedApiResult;
  }
}

@end
