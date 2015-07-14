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

@interface MainTabBarController () <QRCodeReaderDelegate>

@property XMMResponseGetByLocationIdentifier *savedApiResult;
@property JGProgressHUD *hud;

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
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(receivedContentByLocationIdentifierError:)
                                               name:@"ContentByLocationIdentifierError"
                                             object:nil];
  
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
   else{
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
  [super viewDidAppear:animated];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  //instead of switching view the qr code scanner will be opened
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  if (viewController == (tabBarController.viewControllers)[3]){
    [self setupAnalytics];
    [[XMMEnduserApi sharedInstance] setQrCodeViewControllerCancelButtonTitle:NSLocalizedString(@"Cancel", nil)];
    [[XMMEnduserApi sharedInstance] startQRCodeReaderFromViewController:self
                                                                didLoad:^(NSString *locationIdentifier, NSString *url) {
                                                                  [self.hud showInView:self.view];
                                                                  [self didScanQR:locationIdentifier withCompleteUrl:url];
                                                                }];
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - XMMEnduserApi Delegate Methods

-(void)didScanQR:(NSString *)result withCompleteUrl:(NSString *)url{
  self.scannedUrl = url;
  
  //old pingeborg stickers get a redirect to the xm.gl url
  if ([url containsString:@"http://pingeb.org/"]) {
    [self sendEventAnalticsWithAction:@"Scanned Sticker" andLabel:@"Old pingeb.org sticker was scanned."];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConntection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [urlConntection start];
  } else if([url containsString:@"xm.gl"]) {
    [self sendEventAnalticsWithAction:@"Scanned Sticker" andLabel:@"xamoom sticker was scanned."];
    
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:result includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                       completion:^(XMMResponseGetByLocationIdentifier *result) {
                                                         [self didLoadDataWithLocationIdentifier:result];
                                                       } error:^(XMMError *error) {
                                                         NSLog(@"OMG: %@", error.message);
                                                         [self errorMessageOnScanning];
                                                       }];
  } else {
    [self sendEventAnalticsWithAction:@"Scanned Sticker - Failed" andLabel:[NSString stringWithFormat:@"Scanning sticker failed - URL: %@", url]];
    [self errorMessageOnScanning];
  }
}

- (void)errorMessageOnScanning {
  [self.hud dismiss];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nothing found!", nil)
                                                      message:NSLocalizedString(@"Scan a pingeb.org sticker.", nil)
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                            otherButtonTitles:nil];
  [alertView show];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
  
  //redirect to xm.gl
  NSURLRequest *newRequest = request;
  if (redirectResponse) {
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:[self getLocationIdentifierFromURL:[newRequest URL].absoluteString] includeStyle:NO includeMenu:NO withLanguage:[XMMEnduserApi sharedInstance].systemLanguage
                                                       completion:^(XMMResponseGetByLocationIdentifier *result) {
                                                         [self didLoadDataWithLocationIdentifier:result];
                                                       } error:^(XMMError *error) {
                                                       }];
    return nil;
  }
  
  return newRequest;
}

- (NSString*)getLocationIdentifierFromURL:(NSString*)URL {
  NSURL* realUrl = [NSURL URLWithString:URL];
  NSString *path = [realUrl path];
  path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
  return path;
}

- (void)didLoadDataWithLocationIdentifier:(XMMResponseGetByLocationIdentifier *)apiResult{
  [[Globals sharedObject] addDiscoveredArtist:apiResult.content.contentId];
  self.savedApiResult = apiResult;
  [self.hud dismiss];
  [self performSegueWithIdentifier:@"showScanResult" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ( [[segue identifier] isEqualToString:@"showScanResult"] ) {
    ScanResultViewController *srvc = [segue destinationViewController];
    srvc.result = self.savedApiResult;
  }
}

#pragma mark - Analytics

- (void)setupAnalytics {
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[[GAIDictionaryBuilder createScreenView] set:@"QR Scanner"
                                                       forKey:kGAIScreenName] build]];
}

- (void)sendEventAnalticsWithAction:(NSString*)action andLabel:(NSString*)label {
  id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
  [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"     // Event category (required)
                                                        action:action  // Event action (required)
                                                         label:label          // Event label
                                                         value:nil] build]];    // Event value
}

@end
