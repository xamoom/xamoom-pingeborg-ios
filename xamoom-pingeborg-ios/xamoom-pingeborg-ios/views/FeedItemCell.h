//
//  RSSFeedItemCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 30/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedItemTitle;
@property (weak, nonatomic) IBOutlet UIImageView *feedItemImage;
@property (weak, nonatomic) IBOutlet UIImageView *feedItemOverlayImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property NSString *contentId;
@property UIImage *image;
@property XMMResponseContent *content;

@end
