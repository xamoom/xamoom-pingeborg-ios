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
 * XMMContentBlock0TableViewCell is used to display download contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock8TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewForBackground;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSString *fileID;
@property (strong, nonatomic) UIImage *contactImage;
@property (strong, nonatomic) UIImage *calendarImage;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;
@property (nonatomic) BOOL offline;

- (void)openLink;

@end

@interface XMMContentBlock8TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
