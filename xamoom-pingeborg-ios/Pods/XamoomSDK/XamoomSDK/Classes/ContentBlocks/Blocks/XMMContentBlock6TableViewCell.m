//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
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

@interface XMMContentBlock6TableViewCell()

@property (nonatomic) UIImage *angleImage;

@end

@implementation XMMContentBlock6TableViewCell

static NSString *contentLanguage;

- (void)awakeFromNib {
  // Initialization code
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  self.angleImage = [UIImage imageNamed:@"angleRight"];
}

- (void)prepareForReuse {
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  
  [self.loadingIndicator stopAnimating];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api {
  self.contentTitleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  self.contentExcerptLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  
  //set content
  self.contentID = block.contentID;
  self.angleImageView.image = self.angleImage;
  
  //init contentBlock
  [self downloadContentBlock:api];
}

- (void)downloadContentBlock:(XMMEnduserApi *)api {
  [self.loadingIndicator startAnimating];
  
  XMMContent *content = [[XMMContentBlocksCache sharedInstance] cachedContent:self.contentID];
  if (content) {
    [self.loadingIndicator stopAnimating];
    [self showBlockData:content];
    return;
  }
  
  [api contentWithID:self.contentID options:XMMContentOptionsPreview completion:^(XMMContent *content, NSError *error) {
    [self.loadingIndicator stopAnimating];
    [[XMMContentBlocksCache sharedInstance] saveContent:content key:content.ID];
    [self showBlockData:content];
  }];
}

- (void)showBlockData:(XMMContent *)content {
  self.content = content;
  
  //set title and excerpt
  self.contentTitleLabel.text = self.content.title;
  self.contentExcerptLabel.text = self.content.contentDescription;
  [self.contentExcerptLabel sizeToFit];
  
  if (self.content.imagePublicUrl == nil) {
    self.contentImageWidthConstraint.constant = 0;
    self.contentTitleLeadingConstraint.constant = 0;
  } else {
    self.contentImageWidthConstraint.constant = 100;
    self.contentTitleLeadingConstraint.constant = 8;
    [self.contentImageView sd_setImageWithURL: [NSURL URLWithString: self.content.imagePublicUrl]];
  }
}

@end
