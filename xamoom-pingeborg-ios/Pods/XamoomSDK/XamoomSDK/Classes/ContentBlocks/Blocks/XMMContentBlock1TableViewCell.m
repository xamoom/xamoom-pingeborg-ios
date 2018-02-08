//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock1TableViewCell.h"

@interface XMMContentBlock1TableViewCell () <XMMMediaFileDelegate>

@property (nonatomic, strong) UIImage *playImage;
@property (nonatomic, strong) UIImage *pauseImage;
@property (nonatomic, strong) XMMMediaFile *mediaFile;

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

- (void)prepareForReuse {
  [super prepareForReuse];
  _progressBar.lineProgress = 0.0f;
  _mediaFile.delegate = nil;
  [_movingBarView stop];
  [_audioControlButton setImage:self.playImage forState:UIControlStateNormal];
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
  self.titleLabel.text = block.title;
  self.artistLabel.text = block.artists;
  
  if (block.fileID == nil) {
    return;
  }
  
  NSURL *url;
  if (offline) {
    url = [self.fileManager urlForSavedData:block.fileID];
  } else {
    url = [[NSURL alloc] initWithString:block.fileID];
  }
  
  _mediaFile = [[XMMAudioManager sharedInstance] createMediaFileForPosition:block.ID
                                                                        url:url
                                                                      title:block.title
                                                                     artist:block.artists];
  _mediaFile.delegate = self;
  [self didUpdatePlaybackPosition:_mediaFile.playbackPosition];
  if (_mediaFile.isPlaying) {
    [self didStart];
  }
}

- (void)didStart {
  NSLog(@"didStart");
  self.playing = YES;
  [self.movingBarView start];
  [self.audioControlButton setImage:self.pauseImage forState:UIControlStateNormal];
}

- (void)didPause {
  NSLog(@"didPause");
  self.playing = NO;
  [self.movingBarView stop];
  [self.audioControlButton setImage:self.playImage forState:UIControlStateNormal];
}

- (void)didStop {
  NSLog(@"didStop");
  self.playing = NO;
  [self.movingBarView stop];
  [self.audioControlButton setImage:self.playImage forState:UIControlStateNormal];
}

- (void)didUpdatePlaybackPosition:(long)playbackPosition {
  float progress = (float)playbackPosition/(float)self.mediaFile.duration;
  self.progressBar.lineProgress = progress;
  
  float songDurationInSeconds = self.mediaFile.playbackPosition;
  self.remainingTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)songDurationInSeconds / 60, (int)songDurationInSeconds % 60];
}

- (IBAction)playButtonTouched:(id)sender {
  if (!self.isPlaying) {
    self.playing = YES;
    [self.audioControlButton setImage:self.pauseImage forState:UIControlStateNormal];
    [_mediaFile start];
  } else {
    self.playing = NO;
    [self.audioControlButton setImage:self.playImage forState:UIControlStateNormal];
    [_mediaFile pause];
  }
}

- (IBAction)forwardButtonTouched:(id)sender {
  [_mediaFile seekForward:30];
}

- (IBAction)backwardButtonTouched:(id)sender {
  [_mediaFile seekBackward:30];
}

#pragma mark - XMMMMusicPlayer delegate

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
  _progressBar.backgroundLineColor = audioPlayerProgressBarBackgroundColor;
}

- (UIColor *)audioPlayerProgressBarBackgroundColor {
  return _progressBar.backgroundLineColor;
}

- (void)setAudioPlayerProgressBarColor:(UIColor *)audioPlayerProgressBarColor {
  _progressBar.foregroundLineColor = audioPlayerProgressBarColor;
}

- (UIColor *)audioPlayerProgressBarColor {
  return _progressBar.foregroundLineColor;
}

- (void)setAudioPlayerTintColor:(UIColor *)audioPlayerTextColors {
  [self changeTextColors:audioPlayerTextColors];
}

- (UIColor *)audioPlayerTintColor {
  return _titleLabel.textColor;
}

#pragma mark - Notification Handler

- (void)pauseAllXMMMusicPlayer {
  [self.movingBarView stop];
  self.playing = NO;
}

@end
