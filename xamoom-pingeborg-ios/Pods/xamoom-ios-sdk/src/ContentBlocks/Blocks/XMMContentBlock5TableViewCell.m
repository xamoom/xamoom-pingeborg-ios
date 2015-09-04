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

#import "XMMContentBlock5TableViewCell.h"

@implementation XMMContentBlock5TableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.ebookImageView.image = [[UIImage imageNamed:@"ebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.ebookImageView.tintColor = [UIColor whiteColor];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInBrowser:)];
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)openInBrowser:(id)sender {
  //open url in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
}


@end
