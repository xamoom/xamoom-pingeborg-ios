//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

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
  
  CGContextMoveToPoint(context, 0, self.drawingFrameSize.height);
  CGContextAddLineToPoint(context, self.drawingFrameSize.width, self.drawingFrameSize.height);
  
  CGContextStrokePath(context);
  
  //progress
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
