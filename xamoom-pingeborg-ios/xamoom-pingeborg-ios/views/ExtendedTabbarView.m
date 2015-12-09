//
//  ExtendedTabbarView.m
//  pingeb.org
//
//  Created by Raphael Seher on 09.12.15.
//  Copyright © 2015 xamoom GmbH. All rights reserved.
//

#import "ExtendedTabbarView.h"

@implementation ExtendedTabbarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)close:(id)sender {
  self.hidden = YES;
}

@end
