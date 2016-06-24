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

#import "NavigationViewController.h"
#import "ExtendedTabbarView.h"
#import "ScanResultViewController.h"

@interface NavigationViewController ()

@property (strong, nonatomic) JGProgressHUD *hud;
@property (strong, nonatomic) ExtendedTabbarView *extendedView;
@property (strong, nonatomic) NSLayoutConstraint *extendedViewTopConstraint;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;

@property (strong, nonatomic) CLBeacon *lastBeacon;
@property (strong, nonatomic) XMMContent *geofence;

@property (nonatomic) double topBarOffset;

@end

@implementation NavigationViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
 
  self.topBarOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + (double)self.navigationBar.frame.size.height;

  [self initExtendedView];
  [self initBeacons];
  [self initGeofence];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
  [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initBeacons {
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"de2b94ae-ed98-11e4-3432-78616d6f6f6d"];
  
  self.beaconRegion = [[CLBeaconRegion alloc]
                       initWithProximityUUID:uuid
                       major:52414
                       identifier:@"pingeborg beacons"];
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  
  if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    [self.locationManager requestAlwaysAuthorization];
  }
  
  [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)initGeofence {
  self.locationManager.distanceFilter = 100.0f; //meter
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  self.locationManager.activityType = CLActivityTypeOther;
}

#pragma mark - iBeacon & Geofence

- (void)initExtendedView {
  self.extendedView = [[[NSBundle mainBundle] loadNibNamed:@"ExtendedTabbarView" owner:self options:nil] firstObject];
  self.extendedView.translatesAutoresizingMaskIntoConstraints = NO;
  
  self.extendedView.titleLabel.text = NSLocalizedString(@"Discovered pingeb.org", nil);
  self.extendedView.descriptionLabel.text = NSLocalizedString(@"open artist description", nil);
  self.extendedView.hidden = YES;
  
  [self.view insertSubview:self.extendedView atIndex:1];
  
  [self.extendedView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:160]];
  
  self.extendedViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.extendedView
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.view addConstraint:self.extendedViewTopConstraint];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0f
                                                         constant:8]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.extendedView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.view
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0f
                                                         constant:-8]];
  
  [self.extendedView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedTabbarExtendedView)]];
  
  UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeExtendedView)];
  swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
  [self.extendedView addGestureRecognizer:swipeRecognizer];
}

- (void)openExtendedView {
  float newConstant = self.topBarOffset + 55;
  
  if (self.extendedViewTopConstraint.constant == newConstant) {
    return;
  }
  
  self.extendedView.hidden = NO;

  [self.view layoutIfNeeded];
  self.extendedViewTopConstraint.constant = newConstant;
  [UIView animateWithDuration:0.7f
                        delay:0.0f
       usingSpringWithDamping:1.0f
        initialSpringVelocity:18.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.view layoutIfNeeded];
                   }
                   completion:^(BOOL completed){
                   }];
}

- (void)closeExtendedView {
  if (self.extendedViewTopConstraint.constant == 0) {
    return;
  }
  
  [self.view layoutIfNeeded];
  
  self.extendedViewTopConstraint.constant = 0;
  [UIView animateWithDuration:0.3f
                        delay:0.0f
       usingSpringWithDamping:5.0f
        initialSpringVelocity:10.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.view layoutIfNeeded];
                   }
                   completion:^(BOOL completed) {
                     self.extendedView.hidden = YES;
                   }];
}

- (void)clickedTabbarExtendedView {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ArtistDetailViewController *artistDetailViewController =
  [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];

  if (self.lastBeacon != nil) {
    [self.hud showInView:self.view animated:YES];
    [[XMMEnduserApi sharedInstance] contentWithBeaconMajor:@52414 minor:self.lastBeacon.minor completion:^(XMMContent *content, NSError *error) {
      [self.hud dismissAnimated:YES];
      if (error != nil) {
        [self showNetworkAlert];
        return;
      }
      
      [self closeExtendedView];
      
      if (![[Globals sharedObject].savedArtits containsString:content.ID]) {
        [[Globals sharedObject] addDiscoveredArtist:content.ID];
      }
      artistDetailViewController.content = content;
      artistDetailViewController.contentId = content.ID;
      self.lastBeacon = nil;
      [self pushViewController:artistDetailViewController animated:YES];
    }];
  }
  
  if (self.geofence != nil) {
    if (![[Globals sharedObject].savedArtits containsString:self.geofence.ID]) {
      [[Globals sharedObject] addDiscoveredArtist:self.geofence.ID];
    }
    artistDetailViewController.contentId = self.geofence.ID;
    self.geofence = nil;
    [self closeExtendedView];

    [self pushViewController:artistDetailViewController animated:YES];
  }
}

- (void)showNetworkAlert {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Woops" message:@"There was a network problem" preferredStyle:UIAlertControllerStyleAlert];
  
  [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [alertController removeFromParentViewController];
  }]];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = [locations firstObject];
  
  [[XMMEnduserApi sharedInstance] contentsWithLocation:location pageSize:10 cursor:nil sort:0 completion:^(NSArray *contents, bool hasMore, NSString *cursor, NSError *error) {
    if (self.lastBeacon == nil && contents.count > 0) {
      self.geofence = [contents firstObject];
      [self openExtendedView];
    }
  }];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {
  if (beacons.count == 0) {
    return;
  }
  
  [self openExtendedView];
  
  if (self.lastBeacon.minor != [beacons firstObject].minor) {
    self.lastBeacon = [beacons firstObject];
    self.geofence = nil;
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
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
