//
//  XMMMusicPlayer.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/05/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "XMMMusicPlayer.h"

@interface XMMMusicPlayer ()

@property CGSize drawingFrameSize;

@property UIImage *audioButtonPlayIcon;
@property UIImage *audioButtonPauseIcon;

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
  //init avplayer with URL
  NSURL *mediaURL = [NSURL URLWithString:self.mediaUrlString];
  self.audioPlayer = [[AVPlayer alloc] initWithURL:mediaURL];
  
  //addPeriodicTimeObserver for remainingTime and progressBar
  __block XMMMusicPlayer *weakSelf = self;
  [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:NULL usingBlock:^(CMTime time) {
    if (!time.value) {
      return;
    } else {
      CGFloat songDuration = CMTimeGetSeconds([weakSelf.audioPlayer.currentItem duration]);
      CGFloat currentSongTime = CMTimeGetSeconds([weakSelf.audioPlayer currentTime]);
      CGFloat remainingSongTime = songDuration - currentSongTime;
      
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
}

#pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  self.drawingFrameSize = self.bounds.size;
  
  CGContextRef context = UIGraphicsGetCurrentContext();

  //draw first line
  CGContextSetLineWidth(context, self.lineWidth);
  
  CGColorRef color = self.backgroundLineColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height);
  CGContextAddLineToPoint(context, self.drawingFrameSize.width, self.drawingFrameSize.height);
  
  CGContextStrokePath(context);
  
  //draw second line
  CGContextSetLineWidth(context, self.lineWidth);
  
  CGColorRef color2 = self.foregroundLineColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color2);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height);
  CGContextAddLineToPoint(context, (self.drawingFrameSize.width * self.lineProgress), self.drawingFrameSize.height);
  
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

@end
