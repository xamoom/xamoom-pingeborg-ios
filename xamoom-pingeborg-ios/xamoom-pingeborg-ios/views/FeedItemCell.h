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

#import <UIKit/UIKit.h>

@interface FeedItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GradientView *feedItemTitleView;
@property (weak, nonatomic) IBOutlet UILabel *feedItemTitle;
@property (weak, nonatomic) IBOutlet UIImageView *feedItemImage;
@property (weak, nonatomic) IBOutlet UIImageView *feedItemOverlayImage;

@property NSString *contentId;
@property UIImage *image;
@property XMMContent *content;

- (void)setupCellWithContent:(XMMContent *)content discoverable:(Boolean)isDiscoverable;

@end
