//
//  MovingBarsView.h
//  XamoomSDK
//
//  Created by Raphael Seher on 04/04/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovingBarsView : UIView <CAAnimationDelegate>

- (void)start;
- (void)stop;

@end
