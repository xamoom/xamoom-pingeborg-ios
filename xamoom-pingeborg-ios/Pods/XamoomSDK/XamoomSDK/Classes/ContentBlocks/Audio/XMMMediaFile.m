//
//  MediaFile.m
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import "XMMMediaFile.h"

@implementation XMMMediaFile

- (id)initWithPlaybackDelegate:(id<XMMPlaybackDelegate>)playbackDelegate ID:(NSString *)ID url:(NSURL *)url title:(NSString *)title artist:(NSString *)artist album:(NSString *)album {
  if (self = [super init]) {
    _playbackDelegate = playbackDelegate;
    _ID = ID;
    _url = url;
    _title = title;
    _artist = artist;
    _album = album;
  }
  return self;
}

- (void)start {
  [_playbackDelegate playFileAt:_ID];
}

- (void)pause {
  [_playbackDelegate pauseFileAt:_ID];
}

- (void)stop {
  [_playbackDelegate stopFileAt:_ID];
}

- (void)seekForward:(long)seekTime {
  [_playbackDelegate seekForwardFileAt:_ID time:seekTime];
}

- (void)seekBackward:(long)seekTime {
  [_playbackDelegate seekBackwardFileAt:_ID time:seekTime];
}

- (void)didStart {
  [_delegate didStart];
  _playing = YES;
}

- (void)didPause {
  [_delegate didPause];
  _playing = NO;
}

- (void)didStop {
  [_delegate didStop];
  _playing = NO;
}

- (void)didUpdatePlaybackPosition:(long)playbackPosition {
  _playbackPosition = playbackPosition;
  [_delegate didUpdatePlaybackPosition:playbackPosition];
}

@end
