//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import "XMMContentBlocks.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * XMMContentBlock5TableViewCell is used to display ebook contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock5TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ebookImageView;

@property (strong, nonatomic) NSString *downloadUrl;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;
@property (nonatomic) BOOL offline;

- (void)openInBrowser:(id)sender;

@end

@interface XMMContentBlock5TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
