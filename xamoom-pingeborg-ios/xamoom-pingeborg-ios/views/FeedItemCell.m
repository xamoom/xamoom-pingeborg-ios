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

#import "FeedItemCell.h"

@interface FeedItemCell()

@end

@implementation FeedItemCell

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)prepareForReuse {
  self.feedItemOverlayImage.hidden = NO;
  self.feedItemOverlayImage.image = nil;
  self.feedItemTitle.text = nil;
  [self.feedItemTitleView setNeedsLayout];
}

- (void)setupCellWithContent:(XMMContent *)content discoverable:(Boolean)isDiscoverable {
  self.feedItemTitle.text = content.title;
  [self.feedItemTitleView setNeedsLayout];
  
  //set image
  [self.feedItemImage sd_setImageWithURL:[NSURL URLWithString:content.imagePublicUrl]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
  
  if (![[[Globals sharedObject] savedArtits] containsString:content.ID]) {
    self.feedItemOverlayImage.hidden = NO;
  } else {
    self.feedItemOverlayImage.hidden = YES;
  }
  
  //overlay image for the first cell "discoverable"
  if (isDiscoverable) {
    self.feedItemOverlayImage.image = [UIImage imageNamed:@"discoverable"];
  }
}

@end
