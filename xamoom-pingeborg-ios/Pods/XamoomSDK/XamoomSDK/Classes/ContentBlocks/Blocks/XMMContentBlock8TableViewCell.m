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

#import "XMMContentBlock8TableViewCell.h"

@implementation XMMContentBlock8TableViewCell

- (void)awakeFromNib {
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
  
  self.calendarImage = [UIImage imageNamed:@"cal"];
  self.contactImage = [UIImage imageNamed:@"contact"];
}

- (void)prepareForReuse {
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style {
  self.titleLabel.text = block.title;
  self.contentTextLabel.text = block.text;
  self.fileID = block.fileID;
  
  [self.icon setImage:[self iconForDownloadType:block.downloadType]];
}

- (UIImage *)iconForDownloadType:(int)downloadType {
  switch (downloadType) {
    case 0: {
      return self.contactImage;
      break;
    }
    case 1: {
      return self.calendarImage;
      break;
    }
    default:
      break;
  }
  
  return nil;
}

- (void)openLink {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fileID]];
}


@end
