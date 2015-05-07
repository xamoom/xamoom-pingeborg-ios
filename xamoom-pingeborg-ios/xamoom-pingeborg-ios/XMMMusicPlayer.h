//
//  XMMMusicPlayer.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/05/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface XMMMusicPlayer : UIView

@property IBInspectable float ringProgress;
@property IBInspectable int ringLineWidth;
@property IBInspectable UIColor *backgroundRingColor;
@property IBInspectable UIColor *foregroundRingColor;

@end
