//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlock6TableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation XMMContentBlock6TableViewCell

static NSString *contentLanguage;

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
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  [self.loadingIndicator startAnimating];
  
  XMMContent *content = [[XMMContentBlocksCache sharedInstance] cachedContent:self.contentId];
  if (content) {
    [self.loadingIndicator stopAnimating];
    [self showBlockData:content];
    return;
  }
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:language full:NO
                                            completion:^(XMMContentById *result) {
                                              [self.loadingIndicator stopAnimating];
                                              [[XMMContentBlocksCache sharedInstance] saveContent:result.content key:self.contentId];
                                              [self showBlockData:result.content];
                                            } error:^(XMMError *error) {
                                            }];
}

- (void)showBlockData:(XMMContent *)content {
  self.content = content;
  
  //set title and excerpt
  self.contentTitleLabel.text = self.content.title;
  self.contentExcerptLabel.text = self.content.descriptionOfContent;
  [self.contentExcerptLabel sizeToFit];
  
  [self.contentImageView sd_setImageWithURL: [NSURL URLWithString: self.content.imagePublicUrl]];
}

+ (NSString *)language {
  return contentLanguage;
}

+ (void)setLanguage:(NSString *)language {
  contentLanguage = language;
}

@end
