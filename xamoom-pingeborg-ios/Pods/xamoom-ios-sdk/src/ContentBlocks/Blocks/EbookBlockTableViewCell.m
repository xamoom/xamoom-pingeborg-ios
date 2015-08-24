//
//  EbookBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "EbookBlockTableViewCell.h"

@implementation EbookBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.ebookImageView.image = [[UIImage imageNamed:@"ebook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.ebookImageView.tintColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (IBAction)downloadButtonClicked:(id)sender {
  //open url in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
}

@end
