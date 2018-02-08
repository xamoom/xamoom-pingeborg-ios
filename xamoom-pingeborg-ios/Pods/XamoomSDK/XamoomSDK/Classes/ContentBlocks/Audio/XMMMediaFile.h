//
//  MediaFile.h
//  XamoomSDK
//
//  Created by Raphael Seher on 18.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMPlaybackDelegate.h"

@protocol XMMMediaFileDelegate <NSObject>

- (void)didStart;
- (void)didPause;
- (void)didStop;
- (void)didUpdatePlaybackPosition:(long)playbackPosition;

@end

@interface XMMMediaFile : NSObject

@property (nonatomic, assign) NSString *ID;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float playbackPosition;
@property (nonatomic, strong) id<XMMMediaFileDelegate> delegate;
@property (nonatomic, strong) id<XMMPlaybackDelegate> playbackDelegate;
@property (nonatomic, getter=isPlaying) Boolean playing;

- (id)initWithPlaybackDelegate:(id<XMMPlaybackDelegate>)playbackDelegate
                            ID:(NSString *)ID
                           url:(NSURL *)url
                         title:(NSString *)title
                        artist:(NSString *)artist
                         album:(NSString *)album;

- (void)start;
- (void)pause;
- (void)stop;
- (void)seekForward:(long)seekTime;
- (void)seekBackward:(long)seekTime;

- (void)didStart;
- (void)didPause;
- (void)didStop;
- (void)didUpdatePlaybackPosition:(long)playbackPosition;

@end
