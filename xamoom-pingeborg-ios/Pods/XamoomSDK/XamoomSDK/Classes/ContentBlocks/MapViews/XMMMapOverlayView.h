//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMMAnnotation.h"
#import "XMMContentBlocks.h"

@interface XMMMapOverlayView : UIView

@property (weak, nonatomic) IBOutlet UILabel *spotTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *spotDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *spotImageView;
@property (weak, nonatomic) IBOutlet UIButton *openContentButton;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;

- (void)displayAnnotation:(XMMAnnotation *)annotation showContent:(bool)showContent;

@end
