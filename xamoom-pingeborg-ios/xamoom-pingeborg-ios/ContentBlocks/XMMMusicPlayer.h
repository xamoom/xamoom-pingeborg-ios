//
//  XMMMusicPlayer.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/05/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//
//! Project version number for XMMMusicPlayer.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

FOUNDATION_EXPORT double XMMMusicPlayerVersionNumber;

//! Project version string for XMMMusicPlayer.
FOUNDATION_EXPORT const unsigned char XMMMusicPlayerVersionString[];

IB_DESIGNABLE
@interface XMMMusicPlayer : UIView

@property IBInspectable float ringProgress;
@property IBInspectable int ringLineWidth;
@property IBInspectable UIColor *backgroundRingColor;
@property IBInspectable UIColor *foregroundRingColor;

@property AVPlayer *audioPlayer;

@property NSString *mediaUrlString;

-(instancetype)initWithMediaUrlString:(NSString*)mediaUrlString;

@end
