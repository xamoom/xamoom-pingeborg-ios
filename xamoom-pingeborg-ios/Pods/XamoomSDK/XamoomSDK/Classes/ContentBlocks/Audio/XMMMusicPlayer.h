//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

FOUNDATION_EXPORT double XMMMusicPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char XMMMusicPlayerVersionString[];

#pragma mark - XMMMusicerPlayerDelegate Protocol

/**
 * XMMMusicPlayerDelegate is used for messages between the XMMMusicPlayer and the UI.
 */
@protocol XMMMusicPlayerDelegate <NSObject>

- (void)didLoadAsset:(AVAsset *)asset;
- (void)updatePlaybackPosition:(CMTime)time;
- (void)finishedPlayback;

/**
 * Notify delegate with the actual remaining song time.
 *
 * @param remainingSongTime - Remaining song time as string with format 0:00
 */
- (void)didUpdateRemainingSongTime:(NSString*)remainingSongTime;

@end

#pragma mark - XMMMusicPlayer Interface

/**
 * The XMMMusicPlayer is our audio-player for streaming audio from the xamoom system.
 */
@interface XMMMusicPlayer : NSObject

@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, weak) id<XMMMusicPlayerDelegate> delegate;

- (id)init;

- (id)initWith:(AVPlayer *)audioPlayer;

- (void)prepareWith:(AVURLAsset *)asset;

/**
 * Audioplayer starts playing.
 */
- (void)play;

/**
 * Audioplayer pauses playing.
 */
- (void)pause;

/**
 * Seeks audio forward.
 */
- (void)forward:(long)time;

/**
 * Seeks audio 30 seconds backward.
 */
- (void)backward:(long)time;

@end
