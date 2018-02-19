//
//  XMMProgressBar.m
//  XamoomSDK
//
//  Created by Raphael Seher on 19.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import "XMMProgressBar.h"

@interface XMMProgressBar()

@property (nonatomic) CGSize drawingFrameSize;

@end

IB_DESIGNABLE
@implementation XMMProgressBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  
  return self;
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

- (void)setLineProgress:(float)lineProgress {
  _lineProgress = lineProgress;
  [self setNeedsDisplay];
}

@end
