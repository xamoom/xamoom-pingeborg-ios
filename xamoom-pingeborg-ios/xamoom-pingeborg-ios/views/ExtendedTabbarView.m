//
//  ExtendedTabbarView.m
//  pingeb.org
//
//  Created by Raphael Seher on 09.12.15.
//  Copyright © 2015 xamoom GmbH. All rights reserved.
//

#import "ExtendedTabbarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExtendedTabbarView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  [self setupView];
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  [self setupView];
  return self;
}

- (void)setupView {
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = 10;
}

@end
