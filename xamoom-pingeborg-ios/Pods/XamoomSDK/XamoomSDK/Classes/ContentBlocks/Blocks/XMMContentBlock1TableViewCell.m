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

#import "XMMContentBlock1TableViewCell.h"

@interface XMMContentBlock1TableViewCell ()

@property (nonatomic, strong) UIImage *playImage;
@property (nonatomic, strong) UIImage *pauseImage;

@end

@implementation XMMContentBlock1TableViewCell

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pauseAllXMMMusicPlayer)
                                               name:@"pauseAllSounds"
                                             object:nil];
  
  [self setupImages];
  self.fileManager = [[XMMOfflineFileManager alloc] init];
  
  [self.audioControlButton setImage:self.playImage
                           forState:UIControlStateNormal];
  
  [super awakeFromNib];
}

- (void)setupImages {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.playImage = [UIImage imageNamed:@"playbutton"
                              inBundle:imageBundle compatibleWithTraitCollection:nil];
  
  self.pauseImage = [UIImage imageNamed:@"pausebutton"
                              inBundle:imageBundle compatibleWithTraitCollection:nil];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.audioPlayerControl.delegate = self;
  if (offline) {
    NSURL *filePath = [self.fileManager urlForSavedData:block.fileID];
    [self.audioPlayerControl initAudioPlayerWithUrlString:filePath.absoluteString];
  } else {
    [self.audioPlayerControl initAudioPlayerWithUrlString:block.fileID];
  }
  self.titleLabel.text = block.title;
  self.artistLabel.text = block.artists;
}

- (IBAction)playButtonTouched:(id)sender {
  if (!self.isPlaying) {
    [self.audioPlayerControl play];
    self.playing = YES;
    [self.movingBarView start];
    [self.audioControlButton setImage:self.pauseImage forState:UIControlStateNormal];
  } else {
    [self.audioPlayerControl pause];
    self.playing = NO;
    [self.movingBarView stop];
    [self.audioControlButton setImage:self.playImage forState:UIControlStateNormal];
  }
}

- (IBAction)backwardButtonTouched:(id)sender {
  [self.audioPlayerControl backward];
}

- (IBAction)forwardButtonTouched:(id)sender {
  [self.audioPlayerControl forward];
}

#pragma mark - XMMMMusicPlayer delegate

- (void)didLoadAsset:(AVURLAsset *)asset {
  if (asset == nil) {
    self.remainingTimeLabel.text = @"-";
    return;
  }
  
  float songDurationInSeconds = CMTimeGetSeconds(asset.duration);
  self.remainingTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)songDurationInSeconds / 60, (int)songDurationInSeconds % 60];
}

- (void)finishedPlayback {
  self.playing = NO;
  [self.movingBarView stop];
  [self.audioControlButton setImage:self.playImage
                           forState:UIControlStateNormal];
}

-(void)didUpdateRemainingSongTime:(NSString *)remainingSongTime {
  self.remainingTimeLabel.text = remainingSongTime;
}

#pragma mark - Notification Handler

- (void)pauseAllXMMMusicPlayer {
  [self.audioPlayerControl pause];
  [self.movingBarView stop];
  self.playing = NO;
}

@end
