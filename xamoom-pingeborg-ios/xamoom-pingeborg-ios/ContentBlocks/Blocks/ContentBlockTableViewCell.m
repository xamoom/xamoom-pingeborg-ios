//
//  ContentBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ContentBlockTableViewCell.h"

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
  
  //download image
  [XMMImageUtility imageWithUrl:self.result.content.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    
    if (image != nil) {
      [self.contentImageView setImage:image];
    } else if (svgImage != nil) {
      SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
      //[svgImageView setFrame:CGRectMake(0, 0, self.contentImageView.frame.size.width, self.contentImageView.frame.size.height)];
      [self.contentImageView addSubview:svgImageView];
      self.contentImageView.image = nil;
    }
    
    NSString *notificationName = @"reloadTableViewForContentBlocks";
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
  }];
}

@end
