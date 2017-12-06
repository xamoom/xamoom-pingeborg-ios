//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMMusicPlayer.h"

@interface XMMMusicPlayer ()

@property (nonatomic) CGSize drawingFrameSize;
@property (strong, nonatomic) UIImage *audioButtonPlayIcon;
@property (strong, nonatomic) UIImage *audioButtonPauseIcon;

@end

IB_DESIGNABLE
@implementation XMMMusicPlayer

@synthesize audioPlayer;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  return self;
}

- (void)initAudioPlayerWithUrlString:(NSString*)mediaUrlString {
  if (self.audioPlayer) {
    return;
  }
  
  //init avplayer with URL
  NSURL *mediaURL = [NSURL URLWithString:mediaUrlString];
  
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:mediaURL options:nil];
  NSArray *keys = [NSArray arrayWithObject:@"playable"];
  
  [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^() {
    self.audioPlayer = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithAsset:asset automaticallyLoadedAssetKeys:keys]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.delegate didLoadAsset:asset];
    });
    
    //addPeriodicTimeObserver for remainingTime and progressBar
    __block XMMMusicPlayer *weakSelf = self;
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:NULL usingBlock:^(CMTime time) {
      if (!time.value) {
        return;
      } else {
        CGFloat songDuration = CMTimeGetSeconds([weakSelf.audioPlayer.currentItem duration]);
        CGFloat currentSongTime = CMTimeGetSeconds([weakSelf.audioPlayer currentTime]);
        CGFloat remainingSongTime = songDuration - currentSongTime;
        
        if (remainingSongTime <= 0) {
          if ([weakSelf.delegate respondsToSelector:@selector(finishedPlayback)]) {
            [weakSelf.delegate finishedPlayback];
            [weakSelf reset];
            
            if ([weakSelf.delegate respondsToSelector:@selector(didUpdateRemainingSongTime:)]) {
              NSString *timeString = [NSString stringWithFormat:@"%d:%02d", (int)songDuration / 60, (int)songDuration %60];
              [weakSelf.delegate performSelector:@selector(didUpdateRemainingSongTime:)
                                      withObject:timeString];
            }
            
            return;
          }
        }
        
        if (!isnan(songDuration)) {
          weakSelf.lineProgress = currentSongTime / songDuration;
          weakSelf.remainingSongTime = [NSString stringWithFormat:@"%d:%02d", (int)remainingSongTime / 60, (int)remainingSongTime %60];
          
          //notify delegate with remainingSongTime
          if ([weakSelf.delegate respondsToSelector:@selector(didUpdateRemainingSongTime:)]) {
            [weakSelf.delegate performSelector:@selector(didUpdateRemainingSongTime:) withObject:weakSelf.remainingSongTime];
          }
        }
      }
      
      [weakSelf setNeedsDisplay];
    }];
  }];
}

- (void)reset {
  [self.audioPlayer seekToTime:kCMTimeZero];
  self.lineProgress = 0;
  [self setNeedsDisplay];
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  self.drawingFrameSize = self.bounds.size;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //background of progress
  CGContextSetLineWidth(context, self.lineWidth);
  
  CGColorRef color = self.backgroundLineColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height - self.lineWidth/2);
  CGContextAddLineToPoint(context, self.drawingFrameSize.width, self.drawingFrameSize.height - self.lineWidth/2);
  
  CGContextStrokePath(context);
  
  //progress
  CGContextSetLineWidth(context, self.lineWidth);
  
  CGColorRef color2 = self.foregroundLineColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color2);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height - self.lineWidth/2);
  CGContextAddLineToPoint(context, (self.drawingFrameSize.width * self.lineProgress), self.drawingFrameSize.height - self.lineWidth/2);
  
  CGContextStrokePath(context);
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark - Audioplayer Controls

- (void)play {
  [self.audioPlayer play];
}

- (void)pause {
  [self.audioPlayer pause];
}

- (void)forward {
  CMTime newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.audioPlayer.currentTime) + 30,
                        self.audioPlayer.currentTime.timescale);
  
  if (CMTimeCompare(newTime, self.audioPlayer.currentItem.duration) >= 0) {
    [self.delegate finishedPlayback];
    [self.audioPlayer seekToTime:newTime];
    [self.audioPlayer pause];
  } else {
    [self.audioPlayer seekToTime:newTime];
  }
}

- (void)backward {
  CMTime newTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.audioPlayer.currentTime) - 30,
                                         self.audioPlayer.currentTime.timescale);
  [self.audioPlayer seekToTime:newTime];
}

@end
