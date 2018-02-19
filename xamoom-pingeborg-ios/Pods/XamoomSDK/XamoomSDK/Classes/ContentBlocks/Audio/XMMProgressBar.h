//
//  XMMProgressBar.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface XMMProgressBar : UIView

@property (nonatomic, strong) IBInspectable UIColor *backgroundLineColor;
@property (nonatomic, strong) IBInspectable UIColor *foregroundLineColor;
@property (nonatomic) IBInspectable float lineProgress;
@property (nonatomic) IBInspectable int lineWidth;

@end
