//
//  GradientBackgroundView.h
//  pingeb.org
//
//  Created by Raphael Seher on 13/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientBackgroundView : UIView

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIColor *firstColor;
@property (strong, nonatomic) UIColor *secondColor;
@property (nonatomic) double opacity;

@end
