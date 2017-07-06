//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * XMMContentBlock2TableViewCell is used to display video contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *playIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;

@end

@interface XMMContentBlock2TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

- (void)openVideo;

@end
