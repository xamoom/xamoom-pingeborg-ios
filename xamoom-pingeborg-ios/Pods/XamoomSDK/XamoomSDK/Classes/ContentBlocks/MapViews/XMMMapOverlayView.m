//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
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
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMMapOverlayView.h"

@interface XMMMapOverlayView()

@property (nonatomic) NSString *contentID;
@property (nonatomic) CLLocationCoordinate2D locationCoordinate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageAspectConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spotImageWidthConstraint;

@end

@implementation XMMMapOverlayView

- (void)displayAnnotation:(XMMAnnotation *)annotation showContent:(bool)showContent {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *libBundle;
  if (url != nil) {
    libBundle = [NSBundle bundleWithURL:url];
  } else {
    libBundle = bundle;
  }
  
  [self.openContentButton setTitle:NSLocalizedStringFromTableInBundle(@"Open", @"Localizable", libBundle, nil) forState:UIControlStateNormal];
  
  self.contentID = annotation.spot.content.ID;
  self.locationCoordinate = annotation.coordinate;
  
  self.spotTitleLabel.text = annotation.spot.name;
  
  self.spotDescriptionLabel.text = annotation.spot.spotDescription;
  [self.spotDistanceLabel sizeToFit];
  
  self.spotDistanceLabel.text = annotation.distance;
  
  self.spotImageAspectConstraint.active = YES;
  self.spotImageWidthConstraint.constant = 153;
  if (annotation.spot.image == nil) {
    self.spotImageAspectConstraint.active = NO;
    self.spotImageWidthConstraint.constant = 0;
  }
  [self needsUpdateConstraints];

  [self.spotImageView sd_setImageWithURL:[NSURL URLWithString:annotation.spot.image] completed:nil];
  
  self.openContentButton.hidden = NO;
  if (self.contentID == nil || !showContent) {
    self.openContentButton.hidden = YES;
  }
}

- (IBAction)routeAction:(id)sender {
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.locationCoordinate addressDictionary:nil];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = self.spotTitleLabel.text;
  
  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
  [mapItem openInMapsWithLaunchOptions:launchOptions];
}

- (IBAction)openAction:(id)sender {
  NSDictionary *userInfo = @{@"contentID":self.contentID};
  [[NSNotificationCenter defaultCenter]
   postNotificationName:XMMContentBlocks.kContentBlock9MapContentLinkNotification
   object:self userInfo:userInfo];
}

@end
