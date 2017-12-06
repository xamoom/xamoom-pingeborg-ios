//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


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
  self.audioControlButton.tintColor = UIColor.blackColor;

  [self.forwardButton setImage:[self.forwardButton.currentImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                      forState:UIControlStateNormal];
  self.forwardButton.tintColor = UIColor.blackColor;
  [self.backwardButton setImage:[self.backwardButton.currentImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                      forState:UIControlStateNormal];
  self.backwardButton.tintColor = UIColor.blackColor;
  
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
  
  self.playImage = [[UIImage imageNamed:@"playbutton"
                               inBundle:imageBundle
          compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.pauseImage = [[UIImage imageNamed:@"pausebutton"
                                inBundle:imageBundle
           compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
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

- (void)didUpdateRemainingSongTime:(NSString *)remainingSongTime {
  self.remainingTimeLabel.text = remainingSongTime;
}

- (void)changeTextColors:(UIColor *)color {
  self.titleLabel.textColor = color;
  self.artistLabel.textColor = color;
  self.remainingTimeLabel.textColor = color;
  self.forwardLabel.textColor = color;
  self.backwardLabel.textColor = color;
  self.forwardButton.tintColor = color;
  self.backwardButton.tintColor = color;
  self.movingBarView.tintColor = color;
  self.audioControlButton.tintColor = color;
}

#pragma mark - Appearance Getters & Setters

- (void)setAudioPlayerBackgroundColor:(UIColor *)audioPlayerBackgroundColor {
  _audioPlayerView.backgroundColor = audioPlayerBackgroundColor;
}

- (UIColor *)audioPlayerBackgroundColor {
  return _audioPlayerView.backgroundColor;
}

- (void)setAudioPlayerProgressBarBackgroundColor:(UIColor *)audioPlayerProgressBarBackgroundColor {
  _audioPlayerControl.backgroundLineColor = audioPlayerProgressBarBackgroundColor;
}

- (UIColor *)audioPlayerProgressBarBackgroundColor {
  return _audioPlayerControl.backgroundLineColor;
}

- (void)setAudioPlayerProgressBarColor:(UIColor *)audioPlayerProgressBarColor {
  _audioPlayerControl.foregroundLineColor = audioPlayerProgressBarColor;
}

- (UIColor *)audioPlayerProgressBarColor {
  return _audioPlayerControl.foregroundLineColor;
}

- (void)setAudioPlayerTintColor:(UIColor *)audioPlayerTextColors {
  [self changeTextColors:audioPlayerTextColors];
}

- (UIColor *)audioPlayerTintColor {
  return _titleLabel.textColor;
}

#pragma mark - Notification Handler

- (void)pauseAllXMMMusicPlayer {
  [self.audioPlayerControl pause];
  [self.movingBarView stop];
  self.playing = NO;
}

@end
