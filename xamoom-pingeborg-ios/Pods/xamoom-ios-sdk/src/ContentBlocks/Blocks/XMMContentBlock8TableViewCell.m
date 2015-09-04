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

#import "XMMContentBlock8TableViewCell.h"

@implementation XMMContentBlock8TableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setDownloadType:(int)type {
  self.downloadType = type;
  [self.icon setImage:[self selectRightIcon]];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInBrowser:)];
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (UIImage*)selectRightIcon {
  //choose the right image according to the downloadType
  switch (self.downloadType) {
    case 0: {
      return [UIImage imageNamed:@"contact"];
      break;
    }
    case 1: {
      return [UIImage imageNamed:@"cal"];
      break;
    }
    default:
      break;
  }
  
  return nil;
}

- (void)openInBrowser:(id)sender {
  //open url in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fileId]];
}


@end
