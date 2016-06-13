//
//  GradientBackgroundView.m
//  pingeb.org
//
//  Created by Raphael Seher on 13/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "GradientBackgroundView.h"

@implementation GradientBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self addBackgroundGradient];
  self.opacity = 1.0f;
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [self addBackgroundGradient];
  self.opacity = 1.0f;
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.gradientLayer.frame = self.bounds;
}

- (void)addBackgroundGradient {
  self.gradientLayer = [CAGradientLayer layer];
  self.gradientLayer.frame = self.bounds;
  self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[self.firstColor CGColor], (id)[self.secondColor CGColor], nil];
  self.gradientLayer.opacity = self.opacity;
  
  [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)setFirstColor:(UIColor *)firstColor {
  _firstColor = firstColor;
  
  [self.gradientLayer removeFromSuperlayer];
  [self addBackgroundGradient];
}

- (void)setSecondColor:(UIColor *)secondColor {
  _secondColor = secondColor;
  
  [self.gradientLayer removeFromSuperlayer];
  [self addBackgroundGradient];
}

- (void)setOpacity:(double)opacity {
  _opacity = opacity;
  
  [self.gradientLayer removeFromSuperlayer];
  [self addBackgroundGradient];
}

@end
