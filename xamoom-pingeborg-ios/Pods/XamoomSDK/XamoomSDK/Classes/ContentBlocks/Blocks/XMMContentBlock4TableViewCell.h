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

#import <UIKit/UIKit.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * LinkBlockTableViewCell is used to display link contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock4TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *linkTextLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForBackgroundColor;

@property (strong, nonatomic) NSString *linkUrl;

@property (nonatomic) UIColor *standardGreyColor;
@property (nonatomic) UIColor *standardTextColor;
@property (nonatomic) UIColor *facebookColor;
@property (nonatomic) UIColor *twitterColor;
@property (nonatomic) UIColor *shopColor;
@property (nonatomic) UIColor *linkedInColor;
@property (nonatomic) UIColor *flickrColor;
@property (nonatomic) UIColor *soundcloudColor;
@property (nonatomic) UIColor *youtubeColor;
@property (nonatomic) UIColor *googleColor;
@property (nonatomic) UIColor *spotifyColor;
@property (nonatomic) UIColor *navigationColor;
@property (nonatomic) UIColor *androidColor;
@property (nonatomic) UIColor *windowsColor;
@property (nonatomic) UIColor *instagramColor;

- (void)openLink;

@end

@interface XMMContentBlock4TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
