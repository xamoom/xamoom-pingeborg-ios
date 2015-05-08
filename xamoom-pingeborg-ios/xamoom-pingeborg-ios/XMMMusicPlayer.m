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

@property UIImage *audioButtonPlayIcon;
@property UIImage *audioButtonPauseIcon;

@property BOOL isPlaying;

@property float totalTime;
@property (nonatomic) float currentTime;

@end

IB_DESIGNABLE
@implementation XMMMusicPlayer

@synthesize songDurationLabel;

-(instancetype)initWithMediaUrlString:(NSString*)mediaUrlString {
  self = [super init];
  if(self) {
    self.mediaUrlString = mediaUrlString;
  }
  return self;
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
  
  self.songDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.drawingFrameSize.width/2)-10, 0, 20, 20)];
  self.songDurationLabel.font = [self.songDurationLabel.font fontWithSize:5];
  
  [self addSubview:self.songDurationLabel];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  self.isPlaying = NO;
  
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.drawingFrameSize = self.bounds.size;
  self.audioButtonPlayIcon = [[UIImage imageNamed:@"angleRight"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.audioButtonPauseIcon = [[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  self.audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.audioButton.imageView.tintColor = self.foregroundRingColor;
  
  [self.audioButton setImage:self.audioButtonPlayIcon forState:UIControlStateNormal]; //Set the title for regular state
  [self.audioButton addTarget:self
                       action:@selector(audioButton:)
             forControlEvents:UIControlEventTouchDown];
  self.audioButton.frame = CGRectMake(0, 0, self.drawingFrameSize.width, self.drawingFrameSize.height); //make the frame
  [self addSubview:self.audioButton]; //add to current view
  
}

- (IBAction)audioButton:(id)sender {
  if (!self.audioPlayer) {
    NSURL *mediaURL = [NSURL URLWithString:self.mediaUrlString];
    self.audioPlayer = [[AVPlayer alloc] initWithURL:mediaURL];
    
    AVPlayerItem *currentItem = self.audioPlayer.currentItem;
    self.totalTime = CMTimeGetSeconds(currentItem.duration);
    self.songDurationLabel.text = [NSString stringWithFormat:@"%f", self.totalTime];
  }
  
  if (!self.isPlaying) {
    //[self.audioButton setImage:self.audioButtonPauseIcon forState:UIControlStateNormal];
    self.isPlaying = YES;
    
    [self.audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
      self.currentTime = CMTimeGetSeconds(time);
    }];
    
    [self.audioPlayer play];
  }
  else {
    //[self.audioButton setImage:self.audioButtonPlayIcon forState:UIControlStateNormal];
    self.isPlaying = NO;
    [self.audioPlayer pause];
  }
}

- (void)prepareForInterfaceBuilder {
  [super prepareForInterfaceBuilder];
}

-(void)setCurrentTime:(float)currentTime {
  //self.songDurationLabel.text = [NSString stringWithFormat:@"%f", currentTime];
  
  AVPlayerItem *currentItem = self.audioPlayer.currentItem;
  self.totalTime = CMTimeGetSeconds(currentItem.duration);
  
  self.ringProgress = currentTime / self.totalTime;
  [self setNeedsDisplay];
}

@end
