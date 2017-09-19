//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <JAMSVGImage/JAMSVGImage.h>
#import <JAMSVGImage/JAMSVGImageView.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * XMMContentBlock0TableViewCell is used to display image contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock3TableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blockImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *imageLeftHorizontalSpaceConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *imageRightHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalSpacingImageTitleConstraint;
@property (nonatomic) NSLayoutConstraint *imageRatioConstraint;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;

@property (strong, nonatomic) NSString *linkUrl;

- (void)openLink;

@end

@interface XMMContentBlock3TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
