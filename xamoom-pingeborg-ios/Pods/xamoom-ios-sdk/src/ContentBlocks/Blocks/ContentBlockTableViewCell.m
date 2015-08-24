//
//  ContentBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ContentBlockTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ContentBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.contentTitleLabel.text = @"";
  self.contentExcerptLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)initContentBlockWithLanguage:(NSString*)language {
  self.contentView.backgroundColor = [UIColor colorWithRed: 222/255.0f green: 222/255.0f blue: 222/255.0f alpha:1.0];
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:language full:NO
                                            completion:^(XMMResponseGetById *result) {
                                              [self.loadingIndicator stopAnimating];
                                              self.contentView.backgroundColor = [UIColor clearColor];
                                              [self showBlockData:result];
                                            } error:^(XMMError *error) {
                                            }];
}

- (void)showBlockData:(XMMResponseGetById *)result {
  self.result = result;
  
  //set title and excerpt
  self.contentTitleLabel.text = self.result.content.title;
  self.contentExcerptLabel.text = self.result.content.descriptionOfContent;
  [self.contentExcerptLabel sizeToFit];
  
  
  [self.contentImageView sd_setImageWithURL: [NSURL URLWithString: self.result.content.imagePublicUrl]];
}

@end
