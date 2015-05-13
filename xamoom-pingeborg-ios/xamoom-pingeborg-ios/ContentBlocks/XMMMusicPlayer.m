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

-(instancetype)initWithMediaUrlString:(NSString*)mediaUrlString {
  self = [super init];
  if(self) {
    self.mediaUrlString = mediaUrlString;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  return self;
}

- (void)startAudioPlayer {
  NSURL *mediaURL = [NSURL URLWithString:self.mediaUrlString];
  self.audioPlayer = [[AVPlayer alloc] initWithURL:mediaURL];
    
  __block XMMMusicPlayer *weakSelf = self;
  [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:NULL usingBlock:^(CMTime time) {
    if (!time.value) {
      return;
    } else {
      CGFloat songDuration = CMTimeGetSeconds([weakSelf.audioPlayer.currentItem duration]);
      CGFloat currentSongTime = CMTimeGetSeconds([weakSelf.audioPlayer currentTime]);
      CGFloat remainingSongTime = songDuration - currentSongTime;
      
      if (!isnan(songDuration)) {
        weakSelf.ringProgress = currentSongTime / songDuration;
        weakSelf.remainingSongTime = [NSString stringWithFormat:@"%d:%02d", (int)remainingSongTime / 60, (int)remainingSongTime %60];
        
        //delegate call [];
        if ([weakSelf.delegate respondsToSelector:@selector(didUpdateRemainingSongTime:)]) {
          [weakSelf.delegate performSelector:@selector(didUpdateRemainingSongTime:) withObject:weakSelf.remainingSongTime];
        }
      }
    }
    
    [weakSelf setNeedsDisplay];
  }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  self.drawingFrameSize = self.bounds.size;
  
  CGContextRef context = UIGraphicsGetCurrentContext();

  //draw first line
  CGContextSetLineWidth(context, self.ringLineWidth);
  
  CGColorRef color = self.backgroundRingColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height);
  CGContextAddLineToPoint(context, self.drawingFrameSize.width, self.drawingFrameSize.height);
  
  CGContextStrokePath(context);
  
  //draw second line
  CGContextSetLineWidth(context, self.ringLineWidth);
  
  CGColorRef color2 = self.foregroundRingColor.CGColor;
  
  CGContextSetStrokeColorWithColor(context, color2);
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height);
  CGContextAddLineToPoint(context, (self.drawingFrameSize.width * self.ringProgress), self.drawingFrameSize.height);
  
  CGContextStrokePath(context);
}

- (void)layoutSubviews {
  [super layoutSubviews];

}

- (IBAction)audioButton:(id)sender {
  if (!self.audioPlayer) {
    NSURL *mediaURL = [NSURL URLWithString:self.mediaUrlString];
    self.audioPlayer = [[AVPlayer alloc] initWithURL:mediaURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseAllXMMMusicPlayer)
                                                 name:@"pauseAllSounds"
                                               object:nil];
  }
}

- (void)play {
  [self.audioPlayer play];
  

}

- (void)pause {
  [self.audioPlayer pause];
}

- (void)pauseAllXMMMusicPlayer {
  [self.audioPlayer pause];
}

@end
