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

@property UILabel *songDurationLabel;
@property UIButton *audioButton;
@property UIActivityIndicatorView *loadingIndicator;

@property UIImage *audioButtonPlayIcon;
@property UIImage *audioButtonPauseIcon;

@property BOOL isPlaying;

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
  
  self.isPlaying = NO;
  
  return self;
}

-(void)dealloc {
  self.audioPlayer = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  self.drawingFrameSize = self.bounds.size;
  
  // Create an oval shape to draw.
  UIBezierPath *backgroundRing = [UIBezierPath bezierPathWithArcCenter:CGPointMake((self.drawingFrameSize.width/2), (self.drawingFrameSize.height/2))
                                                                radius:((self.drawingFrameSize.width/2)-(self.ringLineWidth/2))
                                                            startAngle:0
                                                              endAngle:2*M_PI
                                                             clockwise:YES];;
  
  // Set the render colors.
  [self.backgroundRingColor setStroke];
  
  CGContextRef aRef = UIGraphicsGetCurrentContext();
  
  // If you have content to draw after the shape,
  // save the current state before changing the transform.
  //CGContextSaveGState(aRef);
  
  // Adjust the view's origin temporarily. The oval is
  // now drawn relative to the new origin point.
  CGContextTranslateCTM(aRef, 0, 0);
  
  // Adjust the drawing options as needed.
  backgroundRing.lineWidth = self.ringLineWidth;
  
  // Fill the path before stroking it so that the fill
  // color does not obscure the stroked line.
  [backgroundRing stroke];
  
  // Restore the graphics state before drawing any other content.
  //CGContextRestoreGState(aRef);
  
  // Create an oval shape to draw.
  UIBezierPath *foregroundRing = [UIBezierPath bezierPathWithArcCenter:CGPointMake((rect.size.width/2), (rect.size.height/2))
                                                                radius:((rect.size.width/2)-(self.ringLineWidth/2))
                                                            startAngle:0
                                                              endAngle:(2*M_PI)*self.ringProgress
                                                             clockwise:YES];
  
  // Set the render colors.
  [self.foregroundRingColor setStroke];
  
  // If you have content to draw after the shape,
  // save the current state before changing the transform.
  //CGContextSaveGState(aRef);
  
  // Adjust the view's origin temporarily. The oval is
  // now drawn relative to the new origin point.
  CGContextTranslateCTM(aRef, 0, 0);
  
  // Adjust the drawing options as needed.
  foregroundRing.lineWidth = self.ringLineWidth;
  
  // Fill the path before stroking it so that the fill
  // color does not obscure the stroked line.
  [foregroundRing stroke];
  
  // Restore the graphics state before drawing any other content.
  //CGContextRestoreGState(aRef);
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.drawingFrameSize = self.bounds.size;
  self.audioButtonPlayIcon = [[UIImage imageNamed:@"playbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.audioButtonPauseIcon = [[UIImage imageNamed:@"pausebutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.audioButton.imageView.tintColor = self.foregroundRingColor;
  
  [self.audioButton setImage:self.audioButtonPlayIcon forState:UIControlStateNormal]; //Set the title for regular state
  [self.audioButton addTarget:self
                       action:@selector(audioButton:)
             forControlEvents:UIControlEventTouchDown];
  self.audioButton.frame = CGRectMake((self.drawingFrameSize.width/2) - (self.audioButtonPlayIcon.size.width/2), (self.drawingFrameSize.height/2) - (self.audioButtonPlayIcon.size.height/2), self.audioButtonPlayIcon.size.width, self.audioButtonPlayIcon.size.height); //make the frame
  [self addSubview:self.audioButton]; //add to current view
  
  self.songDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.drawingFrameSize.width/2)-15, self.drawingFrameSize.height-35, 30, 30)];
  self.songDurationLabel.textAlignment = NSTextAlignmentCenter;
  self.songDurationLabel.font = [self.songDurationLabel.font fontWithSize:10];
  self.songDurationLabel.text = @"0:00";
  
  [self addSubview:self.songDurationLabel];
  
  self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.drawingFrameSize.width/2)-15, (self.drawingFrameSize.height/2)-15, 30, 30)];
  self.loadingIndicator.hidesWhenStopped = YES;
  self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [self addSubview:self.loadingIndicator];
}

- (IBAction)audioButton:(id)sender {
  if (!self.audioPlayer) {
    NSURL *mediaURL = [NSURL URLWithString:self.mediaUrlString];
    self.audioPlayer = [[AVPlayer alloc] initWithURL:mediaURL];
    [self.loadingIndicator startAnimating];
  }
  
  if (!self.isPlaying) {
    [self.audioButton setImage:self.audioButtonPauseIcon forState:UIControlStateNormal];
    self.isPlaying = YES;
    [self.audioPlayer play];

    //updating time on UI
    
    __block XMMMusicPlayer *weakSelf = self;
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:NULL usingBlock:^(CMTime time) {
      if (!time.value) {
        return;
      } else {
        CGFloat songDuration = CMTimeGetSeconds([weakSelf.audioPlayer.currentItem duration]);
        CGFloat currentSongTime = CMTimeGetSeconds([weakSelf.audioPlayer currentTime]);
        CGFloat remainingSongTime = songDuration - currentSongTime;
        
        if (!isnan(songDuration)) {
          weakSelf.ringProgress = currentSongTime / songDuration;
          weakSelf.songDurationLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)remainingSongTime / 60, (int)remainingSongTime %60];
        }
        
        [weakSelf.loadingIndicator stopAnimating];
        [weakSelf setNeedsDisplay];
      }
    }];
  }
  else {
    [self.audioButton setImage:self.audioButtonPlayIcon forState:UIControlStateNormal];
    self.isPlaying = NO;
    [self.audioPlayer pause];
  }
}

- (void)prepareForInterfaceBuilder {
  [super prepareForInterfaceBuilder];
  
  [self addSubview:self.loadingIndicator];
  [self addSubview:self.songDurationLabel];
}

@end
