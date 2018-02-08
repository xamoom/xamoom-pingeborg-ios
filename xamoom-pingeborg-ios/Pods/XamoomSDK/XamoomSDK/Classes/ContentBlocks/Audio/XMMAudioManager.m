//
//  XMMAudioManager.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#include <math.h>

#import "XMMAudioManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XMMAudioManager() <XMMPlaybackDelegate, XMMMusicPlayerDelegate>

@property (nonatomic, strong) NSMutableDictionary *mediaFiles;
@property (nonatomic, strong) XMMMediaFile *currentMediaFile;

@end

@implementation XMMAudioManager

+ (id)sharedInstance {
  static XMMAudioManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (id)init {
  if (self = [super init]) {
    _musicPlayer = [[XMMMusicPlayer alloc] init];
    _musicPlayer.delegate = self;
    _mediaFiles = [[NSMutableDictionary alloc] init];
    _seekTimeForControlCenter = @(30);
    [self setupAudioSession];
    [self setupControlCenterCommands];
  }
  return self;
}

- (void)setupAudioSession {
  NSError *myErr;
  if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
    NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
  } else{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  }
}

- (void)setupControlCenterCommands {
  MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
  MPSkipIntervalCommand *skipBackwardIntervalCommand = [rcc skipBackwardCommand];
  [skipBackwardIntervalCommand setEnabled:YES];
  [skipBackwardIntervalCommand addTarget:self action:@selector(skipBackwardEvent:)];
  skipBackwardIntervalCommand.preferredIntervals = @[_seekTimeForControlCenter];
  
  MPSkipIntervalCommand *skipForwardIntervalCommand = [rcc skipForwardCommand];
  skipForwardIntervalCommand.preferredIntervals = @[_seekTimeForControlCenter];
  [skipForwardIntervalCommand setEnabled:YES];
  [skipForwardIntervalCommand addTarget:self action:@selector(skipForwardEvent:)];
  
  MPRemoteCommand *pauseCommand = [rcc pauseCommand];
  [pauseCommand setEnabled:YES];
  [pauseCommand addTarget:self action:@selector(pauseEvent:)];
  
  MPRemoteCommand *playCommand = [rcc playCommand];
  [playCommand setEnabled:YES];
  [playCommand addTarget:self action:@selector(playEvent:)];
}

- (XMMMediaFile *)createMediaFileForPosition:(NSString *)ID url:(NSURL *)url title:(NSString *)title artist:(NSString *)artist {
  XMMMediaFile *mediaFile = [self mediaFileForPosition:ID];
  
  if (mediaFile == nil ||
      ![mediaFile.url.absoluteString isEqualToString:url.absoluteString]) {
    mediaFile = [[XMMMediaFile alloc] initWithPlaybackDelegate:self ID:ID url:url title:title artist:artist album:nil];
  }
  
  [_mediaFiles setValue:mediaFile forKey:ID];
  
  return mediaFile;
}

- (XMMMediaFile *)mediaFileForPosition:(NSString *)ID {
  return [_mediaFiles objectForKey:ID];
}

- (void)playFileAt:(NSString *)ID {
  XMMMediaFile *mediaFile = [_mediaFiles objectForKey:ID];
  if (_currentMediaFile == nil || _currentMediaFile != mediaFile) {
    if (_currentMediaFile != nil) {
      [_currentMediaFile pause];
    }
    
    _currentMediaFile = mediaFile;
    [_musicPlayer prepareWith:
     [[AVURLAsset alloc] initWithURL:_currentMediaFile.url options:nil]];
  } else {
    [_musicPlayer play];
    [_currentMediaFile didStart];
  }
}

- (void)pauseFileAt:(NSString *)ID {
  if (_currentMediaFile == nil) {
    return;
  }
  
  [_musicPlayer pause];
  [_currentMediaFile didPause];
}

- (void)stopFileAt:(NSString *)ID {
  [_musicPlayer pause];
  _currentMediaFile = nil;
  [_currentMediaFile didStop];
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}

- (void)seekForwardFileAt:(NSString *)ID time:(long)seekTime {
  [_musicPlayer forward:seekTime];
}

- (void)seekBackwardFileAt:(NSString *)ID time:(long)seekTime {
  [_musicPlayer backward:seekTime];
}

- (void)didLoadAsset:(AVAsset *)asset {
  _currentMediaFile.duration = CMTimeGetSeconds(asset.duration);
  
  [_musicPlayer forward:_currentMediaFile.playbackPosition];
  
  [_musicPlayer play];
  [self updateInfoCenterMedia];
  [_currentMediaFile didStart];
}

- (void)updatePlaybackPosition:(CMTime)time {
  float seconds = CMTimeGetSeconds(time);
  if (!isnan(seconds)) {
    _currentMediaFile.playbackPosition = seconds;
    [self updateInfoCenterMedia];
    [_currentMediaFile.delegate didUpdatePlaybackPosition:seconds];
  }
}

- (void)finishedPlayback {
  [_currentMediaFile.delegate didStop];
}

#pragma mark - MPRemoteControlCenter

- (void)skipBackwardEvent:(MPSkipIntervalCommandEvent *)skipEvent {
  [_currentMediaFile seekBackward:skipEvent.interval];
}

- (void)skipForwardEvent:(MPSkipIntervalCommandEvent *)skipEvent {
  [_currentMediaFile seekForward:skipEvent.interval];
}

- (void)playEvent:(MPRemoteCommandEvent *)event {
  [_currentMediaFile start];
}

- (void)pauseEvent:(MPRemoteCommandEvent *)event {
  [_currentMediaFile pause];
}

- (void)updateInfoCenterMedia {
  NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
  if (_currentMediaFile.title != nil) {
    [songInfo setObject:_currentMediaFile.title
                 forKey:MPMediaItemPropertyTitle];
  }
  
  if (_currentMediaFile.artist != nil) {
    [songInfo setObject:_currentMediaFile.artist
                 forKey:MPMediaItemPropertyArtist];
  }
  
  if (_currentMediaFile.duration > 0) {
    [songInfo setObject:@(_currentMediaFile.duration)
                 forKey:MPMediaItemPropertyPlaybackDuration];
  }
  
  if (_currentMediaFile.playbackPosition > 0) {
    [songInfo setObject:@(_currentMediaFile.playbackPosition)
                 forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
  }
  
  [songInfo setObject:@(1.0)
               forKey:MPNowPlayingInfoPropertyPlaybackRate];
  
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

- (void)resetMediaFiles {
  [_mediaFiles removeAllObjects];
  [_mediaFiles setObject:_currentMediaFile forKey:_currentMediaFile.ID];
}

@end
