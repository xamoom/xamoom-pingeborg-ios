//
//  ImageBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBlockTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;

@end
