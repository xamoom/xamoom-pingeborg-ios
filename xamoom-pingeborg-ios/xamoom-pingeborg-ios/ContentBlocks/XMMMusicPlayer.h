//
//  XMMMusicPlayer.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/05/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//
//! Project version number for XMMMusicPlayer.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

FOUNDATION_EXPORT double XMMMusicPlayerVersionNumber;

FOUNDATION_EXPORT const unsigned char XMMMusicPlayerVersionString[];

#pragma mark - XMMMusicerPlayerDelegate Protocol

@protocol XMMMusicerPlayerDelegate <NSObject>

/**
 Notify delegate with the actual remaining song time.
 
 @param remainingSongTime - Remaining song time as string with format 0:00
 @return void
 */
- (void)didUpdateRemainingSongTime:(NSString*)remainingSongTime;

@end

#pragma mark - XMMMusicPlayer Interface

IB_DESIGNABLE
@interface XMMMusicPlayer : UIView

@property IBInspectable UIColor *backgroundLineColor;
@property IBInspectable UIColor *foregroundLineColor;
@property IBInspectable float lineProgress;
@property IBInspectable int lineWidth;
@property AVPlayer *audioPlayer;
@property NSString *mediaUrlString;
@property NSString *remainingSongTime;
@property (nonatomic, weak) id<XMMMusicerPlayerDelegate> delegate;

/**
 Initialize the avplayer and also add the periodicTimeObserver.
 After initialization you are able to get the song duration.
 
 @param mediaUrlString - String of an url to a mediafile like www.xamoom.com/song.mp3
 */
- (void)initAudioPlayerWithUrlString:(NSString*)mediaUrlString;

/**
 Audioplayer starts playing.
 */
- (void)play;

/**
 Audioplayer pauses playing.
 */
- (void)pause;

@end
