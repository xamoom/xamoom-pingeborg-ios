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

#import "MainTabBarController.h"
#import "XMMEnduserApi.h"
#import "ScanResultViewController.h"
#import "ExtendedTabbarView.h"
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>

@interface MainTabBarController () <QRCodeReaderDelegate>

@property (strong, nonatomic) XMMContent *savedApiResult;
@property (strong, nonatomic) JGProgressHUD *hud;
@property (strong, nonatomic) ExtendedTabbarView *extendedView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@property (strong, nonatomic) CLBeacon *lastBeacon;
@property (strong, nonatomic) XMMContent *geofence;

@end

@implementation MainTabBarController


#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.delegate = self;
  [self initTabbarItems];
  [self initBeacons];
  [self initGeofence];
  [self initExtendedView];
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

- (void)initBeacons {
  //create UUID with xamooms Beacon UUID
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"de2b94ae-ed98-11e4-3432-78616d6f6f6d"];
  
  //create beacon region your major
  self.beaconRegion = [[CLBeaconRegion alloc]
                       initWithProximityUUID:uuid
                       major:52414
                       identifier:@"pingeborg beacons"];
  
  //init locationmanager
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  //request location permission
  if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [self.locationManager requestAlwaysAuthorization];
  }
  
  //start monitoring beacons
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)initGeofence {
  self.locationManager.distanceFilter = 100.0f; //meter
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.activityType = CLActivityTypeOther;
  [self.locationManager startUpdatingLocation];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  //instead of switching view the qr code scanner will be opened
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
  
  if (viewController == (tabBarController.viewControllers)[3]){
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"QR Code Reader" andValue:nil];
    
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    QRCodeReaderViewController *qrCodeReaderViewController = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:NSLocalizedString(@"Cancel", nil) codeReader:reader startScanningAtLoad:YES];
    qrCodeReaderViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    qrCodeReaderViewController.delegate = self;
    
    [self presentViewController:qrCodeReaderViewController animated:YES completion:nil];
    
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - iBeacon & Geofence

- (void)initExtendedView {
  self.extendedView = [[[NSBundle mainBundle] loadNibNamed:@"ExtendedTabbarView" owner:self options:nil] firstObject];
  self.extendedView.translatesAutoresizingMaskIntoConstraints = NO;
  self.extendedView.hidden = YES;
  
  self.extendedView.titleLabel.text = NSLocalizedString(@"Discovered pingeb.org", nil);
  self.extendedView.descriptionLabel.text = NSLocalizedString(@"open artist description", nil);
  
  [self.view addSubview:self.extendedView];
  
  [self.extendedView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:70]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.0f
                                                         constant:-49]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0f
                                                         constant:0]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0f
                                                         constant:0]];
  [self.view updateConstraints];
  [self.extendedView updateConstraints];
  
  [self.extendedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedTabbarExtendedView)]];
}

- (void)openExtendedView {
  self.extendedView.hidden = NO;
}

- (void)closeExtendedView {
  self.extendedView.hidden = YES;
}

- (void)clickedTabbarExtendedView {
  [self closeExtendedView];
  
  if (self.lastBeacon != nil) {
    [self.hud showInView:self.view];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanResultViewController *scanResultViewController = [storyboard instantiateViewControllerWithIdentifier:@"ScanResultViewController"];
    
    [[XMMEnduserApi sharedInstance] contentWithBeaconMajor:@52414 minor:self.lastBeacon.minor completion:^(XMMContent *content, NSError *error) {
      [self.hud dismiss];
      if (![[Globals sharedObject].savedArtits containsString:content.ID]) {
        [[Globals sharedObject] addDiscoveredArtist:content.ID];
      }
      scanResultViewController.result = content;
      [self.navigationController pushViewController:scanResultViewController animated:YES];
    }];
    
  }
  
  if (self.geofence != nil) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArtistDetailViewController *artistDetailViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
    
    artistDetailViewController.contentId = self.geofence.ID;
    
    if (![[Globals sharedObject].savedArtits containsString:self.geofence.ID]) {
      [[Globals sharedObject] addDiscoveredArtist:self.geofence.ID];
    }
    
    [self.navigationController pushViewController:artistDetailViewController animated:YES];
  }
}

#pragma mark - XMMEnduserApi Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)url {
  [reader stopScanning];
  self.scannedUrl = url;
  
  //old pingeborg stickers get a redirect to the xm.gl url
  if ([url containsString:@"pingeb.org/"]) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"pingeb.org Sticker" andValue:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *urlConntection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [urlConntection start];
  } else if([url containsString:@"xm.gl"]) {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"xm.gl Sticker" andValue:nil];
    
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:[self getLocationIdentifierFromURL:url]
                                                       completion:^(XMMContent *content, NSError *error) {
                                                         [self dismissViewControllerAnimated:reader completion:nil];
                                                         [self didLoadDataWithLocationIdentifier:content];
                                                       }];
  } else {
    //analytics
    [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Scan" andLabel:@"Other QR Code" andValue:nil];
    [self errorMessageOnScanning];
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

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
  //redirect to xm.gl
  NSURLRequest *newRequest = request;
  if (redirectResponse) {
    [[XMMEnduserApi sharedInstance] contentWithLocationIdentifier:[self getLocationIdentifierFromURL:[newRequest URL].absoluteString] completion:^(XMMContent *content, NSError *error) {
      [self didLoadDataWithLocationIdentifier:content];
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

- (void)didLoadDataWithLocationIdentifier:(XMMContent *)content {
  [[Globals sharedObject] addDiscoveredArtist:content.ID];
  self.savedApiResult = content;
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

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations firstObject];
  
  [[XMMEnduserApi sharedInstance] contentsWithLocation:location pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    if (self.lastBeacon == nil && contents != nil) {
      [self openExtendedView];
      self.geofence = [contents firstObject];
    }
  }];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
  if (beacons.count == 0) {
    [self closeExtendedView];
    return;
  }
  
  [self openExtendedView];
  
  if (self.lastBeacon.minor != [beacons firstObject].minor) {
    self.lastBeacon = [beacons firstObject];
    self.geofence = nil;
  }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
  self.lastBeacon = nil;
  [self closeExtendedView];
}

@end
