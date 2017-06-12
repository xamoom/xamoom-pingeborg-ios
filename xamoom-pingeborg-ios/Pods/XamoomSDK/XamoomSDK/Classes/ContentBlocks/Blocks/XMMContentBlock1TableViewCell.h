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
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XMMMusicPlayer.h"
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"
#import "MovingBarsView.h"

/**
 * XMMContentBlock1TableViewCell is used to display the XMMMusicPlayer for audio contentBlocks form the xamoom system.
 */
@interface XMMContentBlock1TableViewCell : UITableViewCell <XMMMusicPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioControlButton;
@property (weak, nonatomic) IBOutlet MovingBarsView *movingBarView;
@property (weak, nonatomic) IBOutlet XMMMusicPlayer *audioPlayerControl;
@property (nonatomic, getter=isPlaying) BOOL playing;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;

- (IBAction)playButtonTouched:(id)sender;

@end

@interface XMMContentBlock1TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
