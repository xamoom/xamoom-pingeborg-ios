//
//  MovingBarsView.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/04/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "MovingBarsView.h"

#define ARC4RANDOM_MAX      0x100000000

@interface MovingBarsView()

@property Boolean running;
@property float lineWidth;
@property float startHeight;
@property float spacing;
@property float maxHeight;
@property NSArray *positions;
@property NSMutableArray *layers;

@end

@implementation MovingBarsView

-(void)awakeFromNib {
  [super awakeFromNib];
  
  self.lineWidth = 6;
  self.startHeight = 3;
  self.spacing = 4;
  self.maxHeight = self.bounds.size.height;
  CGFloat width = self.bounds.size.width;
  
  NSNumber *position1 = [NSNumber numberWithInt: width - self.lineWidth/2];
  int positionDiff = [position1 integerValue] - self.lineWidth / 2 - self.spacing;
  NSNumber *position2 = [NSNumber numberWithInt: positionDiff];
  positionDiff = [position2 integerValue] - self.lineWidth / 2 - self.spacing;
  NSNumber *position3 = [NSNumber numberWithInt: positionDiff];
  
  self.positions = [[NSArray alloc] initWithObjects:position1, position2, position3, nil];
  [self setupLayers];
}

- (void)setupLayers {
  self.layers = [[NSMutableArray alloc] init];
  
  for (NSNumber *startPosition in self.positions) {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.position = CGPointMake(0, 0);
    layer.strokeColor = [UIColor blackColor].CGColor;
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake([startPosition floatValue], self.maxHeight)];
    [linePath addLineToPoint:CGPointMake([startPosition floatValue], 0)];
    layer.path=linePath.CGPath;
    layer.lineWidth = self.lineWidth;
    
    [self.layers addObject:layer];
    [self.layer addSublayer:layer];
    
    layer.strokeEnd = (self.startHeight / self.maxHeight);
    layer.strokeStart = 0;
  }
}

- (void)start {
  self.running = YES;
  [self startAnimations];
}

- (void)stop {
  self.running = NO;
  [self stopAnimations];
}

- (void)layoutSubviews {
  for (CALayer *layer in self.layers) {
    [layer removeFromSuperlayer];
  }
  
  self.maxHeight = self.bounds.size.height;
  [self setupLayers];
}

- (void)startAnimations {
  for (CAShapeLayer *layer in self.layers) {
    NSNumber *toValue = [NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)];
    CABasicAnimation *animation = [self strokeAnimationFrom:[NSNumber numberWithFloat:layer.strokeEnd]
                                                         to:toValue];
    [layer addAnimation:animation forKey:@"strokeEnd"];
  }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  CALayer *currentLayer = nil;
  for (CALayer *layer in self.layers) {
    if (anim == [layer animationForKey:@"strokeEnd"]) {
      currentLayer = layer;
    }
  }
  [currentLayer removeAllAnimations];
  
  CABasicAnimation *oldAnimation = (CABasicAnimation *) anim;
  NSNumber *fromValue = oldAnimation.toValue;
  NSNumber *toValue = [NSNumber numberWithFloat:((double)arc4random() / ARC4RANDOM_MAX)];
  CABasicAnimation *newAnimation = [self strokeAnimationFrom:fromValue
                                                          to:toValue];
  [currentLayer addAnimation:newAnimation forKey:@"strokeEnd"];
}

- (CABasicAnimation *)strokeAnimationFrom:(NSNumber *)from to:(NSNumber *)to {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  animation.fromValue = from;
  animation.toValue = to;
  animation.delegate = self;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  
  return animation;
}

- (void)stopAnimations {
  for (CALayer *layer in self.layers) {
    CABasicAnimation *animation = (CABasicAnimation *) [layer animationForKey:@"strokeEnd"];
    CABasicAnimation *endAnimation =
    [self strokeAnimationFrom:animation.toValue
                           to:[NSNumber numberWithFloat:(self.startHeight / self.maxHeight)]];
    [layer removeAnimationForKey:@"strokeEnd"];
    [layer addAnimation:endAnimation forKey:@"end"];
  }
}

@end
