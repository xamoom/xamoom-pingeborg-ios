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
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlock4TableViewCell.h"

@implementation XMMContentBlock4TableViewCell

- (void)awakeFromNib {
  // Initialization code
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInBrowser:)];
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)openInBrowser:(id)sender {
  //open link in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
}

- (void)changeStyleAccordingToLinkType {
  
  switch (self.linkType) {
    case 0: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"facebook"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 1: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:0.10 green:0.56 blue:0.91 alpha:1.0]];
      [self.icon setImage:[UIImage imageNamed:@"twitter"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 2: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"web"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
    }
    case 3: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:255/255.0f green:153/255.0f blue:0/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"shop"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 4: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"wikipedia"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
    }
    case 5: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:9/255.0f green:118/255.0f blue:180/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"linkedin"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 6: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:132/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"flickr"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 7: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:255/255.0f green:136/255.0f blue:0/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"soundcloud"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 8: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"itunes"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
    }
    case 9: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:179/255.0f green:18/255.0f blue:23/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"youtube"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 10: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:221/255.0f green:75/255.0f blue:57/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"google"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 11: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"phone"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
    }
    case 12: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"email"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
    }
    case 13: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:0.18 green:0.74 blue:0.35 alpha:1.0]];
      [self.icon setImage:[UIImage imageNamed:@"spotify"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor blackColor]];
      [self.linkTextLabel setTextColor:[UIColor blackColor]];
      [self.titleLabel setTextColor:[UIColor blackColor]];
      break;
    }
    case 14: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:13/255.0f green:163/255.0f blue:96/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"directional"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 15: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor blackColor]];
      [self.icon setImage:[UIImage imageNamed:@"apple"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 16: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:0.32 green:0.42 blue:0.00 alpha:1.0]];
      [self.icon setImage:[UIImage imageNamed:@"android"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    case 17: {
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:0.17 green:0.38 blue:0.94 alpha:1.0]];
      [self.icon setImage:[UIImage imageNamed:@"windows"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor whiteColor]];
      [self.linkTextLabel setTextColor:[UIColor whiteColor]];
      [self.titleLabel setTextColor:[UIColor whiteColor]];
      break;
    }
    default:
      NSLog(@"Linktype not recognized.");
      [self.viewForBackgroundColor setBackgroundColor:[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f]];
      [self.icon setImage:[UIImage imageNamed:@"web"]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.linkTextLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      [self.titleLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
      break;
  }
}

@end
