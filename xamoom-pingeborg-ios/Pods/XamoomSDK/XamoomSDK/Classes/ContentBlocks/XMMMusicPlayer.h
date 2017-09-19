//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

FOUNDATION_EXPORT double XMMMusicPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char XMMMusicPlayerVersionString[];

#pragma mark - XMMMusicerPlayerDelegate Protocol

/**
 * XMMMusicPlayerDelegate is used for messages between the XMMMusicPlayer and the UI.
 */
@protocol XMMMusicPlayerDelegate <NSObject>

- (void)didLoadAsset:(AVURLAsset *)asset;
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
IB_DESIGNABLE
@interface XMMMusicPlayer : UIView

@property (nonatomic, strong) IBInspectable UIColor *backgroundLineColor;
@property (nonatomic, strong) IBInspectable UIColor *foregroundLineColor;
@property (nonatomic) IBInspectable float lineProgress;
@property (nonatomic) IBInspectable int lineWidth;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) NSString *remainingSongTime;
@property (nonatomic, weak) id<XMMMusicPlayerDelegate> delegate;

/**
 * Initialize the avplayer and also add the periodicTimeObserver.
 * After initialization you are able to get the song duration.
 *
 * @param mediaUrlString - String of an url to a mediafile like www.xamoom.com/song.mp3
 */
- (void)initAudioPlayerWithUrlString:(NSString*)mediaUrlString;

/**
 * Audioplayer starts playing.
 */
- (void)play;

/**
 * Audioplayer pauses playing.
 */
- (void)pause;

/**
 * Seeks audio 30 seconds forward.
 */
- (void)forward;

/**
 * Seeks audio 30 seconds backward.
 */
- (void)backward;

@end
