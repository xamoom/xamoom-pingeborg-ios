//
//  DownloadBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadBlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) int downloadType;
@property NSString *fileId;

- (IBAction)linkButtonAction:(id)sender;

@end
