//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import <AVFoundation/AVFoundation.h>
#import "MainTabBarController.h"
#import "XMMEnduserApi.h"
#import "ScanResultViewController.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>

@interface MainTabBarController () <QRCodeReaderDelegate>

@property (strong, nonatomic) XMMContent *savedApiResult;
@property (strong, nonatomic) JGProgressHUD *hud;
@property (nonatomic) double topBarOffset;

@end

@implementation MainTabBarController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.delegate = self;
  [self initTabbarItems];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)initTabbarItems {
  //center tabbar images
  for (UITabBarItem *item in self.tabBar.items) {
    [item setImageInsets:UIEdgeInsetsMake(4,0,-4,0)];
    
    //"hide" the title, to have better accessibility instead of don't set the item name
    item.titlePositionAdjustment = UIOffsetMake(0, 100);
  }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  //instead of switching view the qr code scanner will be opened
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  if (viewController == (tabBarController.viewControllers)[3]){
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"QR Code Reader" andValue:nil];
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *qrCodeReaderViewController =
    [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                       codeReader:reader startScanningAtLoad:YES];
    qrCodeReaderViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    qrCodeReaderViewController.delegate = self;
    
    [self presentViewController:qrCodeReaderViewController animated:YES completion:nil];
    
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - QRCodeReaderViewController Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)url {
  [reader stopScanning];
  self.scannedUrl = url;
  
  AudioServicesPlaySystemSound(1111);
  
  //old pingeborg stickers get a redirect to the xm.gl url
  if ([url containsString:@"pingeb.org/"] && ![url containsString:@"m.pingeb.org/"]) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"pingeb.org Sticker" andValue:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConntection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [urlConntection start];
  } else {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"xm.gl Sticker" andValue:nil];
    
    NSString *identifier = [self getLocationIdentifierFromURL:url];
    if (identifier == nil) {
      [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"Other QR Code" andValue:nil];
      [self errorMessageOnScanning];
      return;
    }
    
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:identifier
                                                       completion:^(XMMContent *content, NSError *error) {
                                                         if (error != nil) {
                                                           [self errorMessageOnScanning];
                                                         }
                                                         
                                                         [reader dismissViewControllerAnimated:YES completion:nil];
                                                         [self didLoadDataWithLocationIdentifier:content];
                                                       }];
  }
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
  [self dismissViewControllerAnimated:YES completion:NULL];
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

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
  //redirect to xm.gl
  NSURLRequest *newRequest = request;
  if (redirectResponse) {
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:[self getLocationIdentifierFromURL:[newRequest URL].absoluteString] completion:^(XMMContent *content, NSError *error) {
      [self didLoadDataWithLocationIdentifier:content];
    }];
    
    return nil;
  } else {
    [self errorMessageOnScanning];
  }
  
  return newRequest;
}

- (NSString*)getLocationIdentifierFromURL:(NSString*)URL {
  NSURL* realUrl = [NSURL URLWithString:URL];
  NSString *path = [realUrl path];
  path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
  return path;
}

- (void)didLoadDataWithLocationIdentifier:(XMMContent *)content {
  [[Globals sharedObject] addDiscoveredArtist:content.ID];
  self.savedApiResult = content;
  [self.hud dismiss];
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ArtistDetailViewController *artistDetailViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
  artistDetailViewController.content = content;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
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
