//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMusicPlayer.h"

@interface XMMMusicPlayer ()

@property Boolean preparing;

@end

@implementation XMMMusicPlayer

#pragma mark - Initialization

- (id)init {
  if (self = [super init]) {
    _audioPlayer = [[AVPlayer alloc] init];
    [self registerObservers];
  }
  return self;
}

- (id)initWith:(AVPlayer *)audioPlayer {
  if (self = [super init]) {
    _audioPlayer = audioPlayer;
    [self registerObservers];
  }
  return self;
}

- (void)registerObservers {
  [_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(itemDidFinishPlaying:)
                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                           object:_audioPlayer.currentItem];
  
  XMMMusicPlayer * __weak weakSelf = self;
  [_audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:nil usingBlock:^(CMTime time) {
    if (!weakSelf.preparing) {
      [weakSelf.delegate updatePlaybackPosition:weakSelf.audioPlayer.currentTime];
    }
  }];
}

- (void)prepareWith:(AVURLAsset *)asset {
  _preparing = YES;
  [asset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
    NSArray *keys = [NSArray arrayWithObject:@"playable"];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:keys];
    
    [_audioPlayer replaceCurrentItemWithPlayerItem:item];
    
    if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
      [_delegate didLoadAsset:_audioPlayer.currentItem.asset];
      _preparing = NO;
    }
  }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if (object == _audioPlayer && [keyPath isEqualToString:@"status"]) {
    if (_audioPlayer.status == AVPlayerStatusFailed) {
      NSLog(@"XMMMusicPlayer - AVPlayer Failed");
    } else if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
      NSLog(@"XMMMusicPlayer - AVPlayerStatusReadyToPlay");
      [_delegate didLoadAsset:_audioPlayer.currentItem.asset];
      _preparing = NO;
    } else if (_audioPlayer.status == AVPlayerItemStatusUnknown) {
      NSLog(@"XMMMusicPlayer - AVPlayer Unknown");
    }
  }
}

- (void)itemDidFinishPlaying:(NSNotification *) notification {
  [self pause];
  [self seekToStart];
  [_delegate finishedPlayback];
}

- (void)seekToStart {
  CMTime time = CMTimeMake(0, _audioPlayer.currentTime.timescale);
  [_audioPlayer seekToTime:time];
}

#pragma mark - Audioplayer Controls

- (void)play {
  [self.audioPlayer play];
}

- (void)pause {
  [self.audioPlayer pause];
}

- (void)forward:(long)time {
  CMTime newTime = CMTimeAdd(self.audioPlayer.currentTime, CMTimeMakeWithSeconds(time, _audioPlayer.currentTime.timescale));
  [self.audioPlayer seekToTime:newTime];
}

- (void)backward:(long)time {
  CMTime newTime = CMTimeSubtract(self.audioPlayer.currentTime, CMTimeMakeWithSeconds(time, _audioPlayer.currentTime.timescale));
  [self.audioPlayer seekToTime:newTime];
}

@end
