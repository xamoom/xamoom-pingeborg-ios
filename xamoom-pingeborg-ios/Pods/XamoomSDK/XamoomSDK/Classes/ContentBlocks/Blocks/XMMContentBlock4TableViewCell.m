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

#import "XMMContentBlock4TableViewCell.h"

@interface XMMContentBlock4TableViewCell()

@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation XMMContentBlock4TableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.linkTextLabel.text = nil;
  self.titleLabel.text = nil;
  self.linkUrl = nil;

  [self setupColors];
  [self setupBundle];
  [super awakeFromNib];
}

- (void)setupColors {
  self.facebookColor = [UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0f];
  self.twitterColor = [UIColor colorWithRed:0.10 green:0.56 blue:0.91 alpha:1.0];
  self.standardGreyColor = [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];
  self.standardTextColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
  self.shopColor = [UIColor colorWithRed:255/255.0f green:153/255.0f blue:0/255.0f alpha:1.0f];
  self.linkedInColor = [UIColor colorWithRed:9/255.0f green:118/255.0f blue:180/255.0f alpha:1.0f];
  self.flickrColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:132/255.0f alpha:1.0f];
  self.soundcloudColor = [UIColor colorWithRed:255/255.0f green:136/255.0f blue:0/255.0f alpha:1.0f];
  self.youtubeColor = [UIColor colorWithRed:179/255.0f green:18/255.0f blue:23/255.0f alpha:1.0f];
  self.googleColor = [UIColor colorWithRed:221/255.0f green:75/255.0f blue:57/255.0f alpha:1.0f];
  self.spotifyColor = [UIColor colorWithRed:0.18 green:0.74 blue:0.35 alpha:1.0];
  self.navigationColor = [UIColor colorWithRed:13/255.0f green:163/255.0f blue:96/255.0f alpha:1.0f];
  self.androidColor = [UIColor colorWithRed:0.32 green:0.42 blue:0.00 alpha:1.0];
  self.windowsColor = [UIColor colorWithRed:0.17 green:0.38 blue:0.94 alpha:1.0];
  self.instagramColor = [UIColor colorWithRed:0.74 green:0.16 blue:0.55 alpha:1.0];
}

- (void)setupBundle {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
}

- (void)prepareForReuse {
  self.linkTextLabel.text = nil;
  self.titleLabel.text = nil;
  self.linkUrl = nil;
}

- (void)openLink {
  //open link in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  //set title, text, linkUrl and linkType
  
  if(block.title != nil) {
    self.titleLabel.text = block.title;
  }
  
  self.linkTextLabel.text = block.text;
  self.linkUrl = block.linkUrl;
  
  [self changeStyleAccordingToLinkType:block.linkType];
}

- (void)changeStyleAccordingToLinkType:(int)linkType {
  switch (linkType) {
    case 0: {
      [self.viewForBackgroundColor setBackgroundColor:self.facebookColor];
      [self.icon setImage:[UIImage imageNamed:@"facebook" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 1: {
      [self.viewForBackgroundColor setBackgroundColor:self.twitterColor];
      [self.icon setImage:[UIImage imageNamed:@"twitter" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 2: {
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"web" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
    }
    case 3: {
      [self.viewForBackgroundColor setBackgroundColor:self.shopColor];
      [self.icon setImage:[UIImage imageNamed:@"shop" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 4: {
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"wikipedia" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
    }
    case 5: {
      [self.viewForBackgroundColor setBackgroundColor:self.linkedInColor];
      [self.icon setImage:[UIImage imageNamed:@"linkedin" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 6: {
      [self.viewForBackgroundColor setBackgroundColor:self.flickrColor];
      [self.icon setImage:[UIImage imageNamed:@"flickr" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 7: {
      [self.viewForBackgroundColor setBackgroundColor:self.soundcloudColor];
      [self.icon setImage:[UIImage imageNamed:@"soundcloud" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 8: {
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"itunes" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
    }
    case 9: {
      [self.viewForBackgroundColor setBackgroundColor:self.youtubeColor];
      [self.icon setImage:[UIImage imageNamed:@"youtube" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 10: {
      [self.viewForBackgroundColor setBackgroundColor:self.googleColor];
      [self.icon setImage:[UIImage imageNamed:@"google" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 11: {
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"phone" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
    }
    case 12: {
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"email" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
    }
    case 13: {
      [self.viewForBackgroundColor setBackgroundColor:self.spotifyColor];
      [self.icon setImage:[UIImage imageNamed:@"spotify" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 14: {
      [self.viewForBackgroundColor setBackgroundColor:self.navigationColor];
      [self.icon setImage:[UIImage imageNamed:@"directional" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 15: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor blackColor]];
      [self.icon setImage:[UIImage imageNamed:@"apple" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 16: {
      [self.viewForBackgroundColor setBackgroundColor:self.androidColor];
      [self.icon setImage:[UIImage imageNamed:@"android" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 17: {
      [self.viewForBackgroundColor setBackgroundColor:self.windowsColor];
      [self.icon setImage:[UIImage imageNamed:@"windows" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 18: {
      [self.viewForBackgroundColor setBackgroundColor:self.instagramColor];
      [self.icon setImage:[UIImage imageNamed:@"instagram" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    default:
      NSLog(@"Linktype not recognized.");
      [self.viewForBackgroundColor setBackgroundColor:self.standardGreyColor];
      [self.icon setImage:[UIImage imageNamed:@"web" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:self.standardTextColor];
      [self.linkTextLabel setTextColor:self.standardTextColor];
      [self.titleLabel setTextColor:self.standardTextColor];
      break;
  }
}

@end
