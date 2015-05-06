//
//  PingeborgCalloutView.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 20/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "PingeborgCalloutView.h"

@implementation PingeborgCalloutView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
  }
  return self;
}

- (instancetype)init{
  id mainView = [[[NSBundle mainBundle] loadNibNamed:@"PingeborgCalloutView" owner:self options:nil] lastObject];
  return mainView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
