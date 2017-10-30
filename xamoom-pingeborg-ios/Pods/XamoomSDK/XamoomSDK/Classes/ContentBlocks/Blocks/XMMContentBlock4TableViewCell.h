//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * LinkBlockTableViewCell is used to display link contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock4TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *linkTextLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForBackgroundColor;

@property (strong, nonatomic) NSString *linkUrl;
@property int linkType;

@property (nonatomic) UIColor *standardGreyColor;
@property (nonatomic) UIColor *standardTextColor;
@property (nonatomic) UIColor *facebookColor;
@property (nonatomic) UIColor *twitterColor;
@property (nonatomic) UIColor *shopColor;
@property (nonatomic) UIColor *linkedInColor;
@property (nonatomic) UIColor *flickrColor;
@property (nonatomic) UIColor *soundcloudColor;
@property (nonatomic) UIColor *youtubeColor;
@property (nonatomic) UIColor *googleColor;
@property (nonatomic) UIColor *spotifyColor;
@property (nonatomic) UIColor *navigationColor;
@property (nonatomic) UIColor *androidColor;
@property (nonatomic) UIColor *windowsColor;
@property (nonatomic) UIColor *instagramColor;
@property (nonatomic) UIColor *phoneColor;

- (void)openLink;

@end

@interface XMMContentBlock4TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
