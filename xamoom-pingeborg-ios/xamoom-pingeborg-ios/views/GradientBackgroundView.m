//
//  GradientBackgroundView.m
//  pingeb.org
//
//  Created by Raphael Seher on 13/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import "GradientBackgroundView.h"

@implementation GradientBackgroundView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [self addBackgroundGradient];
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.gradientLayer.frame = self.bounds;
}

- (void)addBackgroundGradient {
  self.gradientLayer = [CAGradientLayer layer];
  self.gradientLayer.frame = self.bounds;
  self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
  self.gradientLayer.opacity = 0.7f;
  
  [self.layer insertSublayer:self.gradientLayer atIndex:0];
}

@end
