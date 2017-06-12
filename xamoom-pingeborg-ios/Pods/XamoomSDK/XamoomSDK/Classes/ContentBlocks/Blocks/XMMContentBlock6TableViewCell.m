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
@property (nonatomic) BOOL offline;
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@end

@implementation XMMContentBlock6TableViewCell

static NSString *contentLanguage;

- (void)awakeFromNib {
  // Initialization code
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.fileManager = [[XMMOfflineFileManager alloc] init];
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  self.angleImage = [UIImage imageNamed:@"angleRight"
                               inBundle:imageBundle compatibleWithTraitCollection:nil];
  [super awakeFromNib];
}

- (void)prepareForReuse {
  self.contentID = nil;
  self.contentImageView.image = nil;
  self.contentTitleLabel.text = nil;
  self.contentExcerptLabel.text = nil;
  
  if (self.dataTask != nil && self.dataTask.state == NSURLSessionTaskStateRunning) {
    [self.dataTask cancel];
  }
  [self.loadingIndicator stopAnimating];
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api offline:(BOOL)offline {
  self.offline = offline;
  if (style.foregroundFontColor != nil) {
    self.contentTitleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
    self.contentExcerptLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  }
  
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
  
  self.dataTask = [api contentWithID:self.contentID options:XMMContentOptionsPreview completion:^(XMMContent *content, NSError *error) {
    if (error) {
      return;
    }
    
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
    [self setNoImageConstraints];
  } else {
    self.contentImageWidthConstraint.constant = 80;
    self.contentTitleLeadingConstraint.constant = 8;
    if (self.offline) {
      NSURL *offlineURL = [self.fileManager urlForSavedData:self.content.imagePublicUrl];
      [self.contentImageView sd_setImageWithURL:offlineURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
          [self setNoImageConstraints];
        }
      }]; 
    } else {
      [self.contentImageView sd_setImageWithURL: [NSURL URLWithString: self.content.imagePublicUrl]];
    }
  }
}

- (void)setNoImageConstraints {
  self.contentImageWidthConstraint.constant = 0;
  self.contentTitleLeadingConstraint.constant = 0;
}

@end
