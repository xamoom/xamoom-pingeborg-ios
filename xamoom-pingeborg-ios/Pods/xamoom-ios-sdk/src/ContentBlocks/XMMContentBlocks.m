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

#import "XMMContentBlocks.h"
#import <SDWebImage/UIImageView+WebCache.h>

int const kHorizontalSpaceToSubview = 32;

#pragma mark - XMMContentBlocks Interface

@interface XMMContentBlocks ()

@property (nonatomic) UITableView *tableView;
@property (nonatomic) BOOL isContentHeaderAdded;

@end

#pragma mark - XMMContentBlocks Implementation

@implementation XMMContentBlocks

- (instancetype)initWithTableView:(UITableView *)tableView language:(NSString *)language {
  self = [super init];
  
  if(self) {
    self.tableView = tableView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
    self.linkColor = [UIColor blueColor];
    self.language = language;
    self.showAllStoreLinks = NO;
    self.isContentHeaderAdded = NO;
    
    [XMMContentBlock0TableViewCell setFontSize: NormalFontSize];
    [XMMContentBlock6TableViewCell setLanguage: language];
    [XMMContentBlock9TableViewCell setLanguage: language];
    [XMMContentBlock9TableViewCell setLinkColor: self.linkColor];
  }
  
  return self;
}

- (void)contentBlocksFromContent {
  self.items = (NSMutableArray *)self.content.contentBlocks;
  
  [self addContentHeader];
  
  if (self.showAllStoreLinks) {
    return;
  }
  
  NSMutableArray *contentBlocks = [(NSMutableArray *)self.content.contentBlocks copy];
  for (XMMContentBlock *contentBlock in contentBlocks) {
    if ([contentBlock isKindOfClass:[XMMContentBlockType4 class]]) {
      XMMContentBlockType4 *linkBlock = (XMMContentBlockType4 *)contentBlock;
      if (linkBlock.linkType == 16 || linkBlock.linkType == 17) {
        [self.items removeObject:contentBlock];
      }
    }
  }
}

- (void)addContentHeader {
  if (self.isContentHeaderAdded) {
    return;
  }
  
  XMMContentBlockType0 *cb0 = [[XMMContentBlockType0 alloc] init];
  cb0.contentBlockType = 0;
  cb0.publicStatus = true;
  cb0.title = self.content.title;
  cb0.text = self.content.descriptionOfContent;
  
  XMMContentBlockType3 *cb3 = [[XMMContentBlockType3 alloc] init];
  cb3.contentBlockType = 3;
  cb3.publicStatus = true;
  cb3.fileId = self.content.imagePublicUrl;
  
  [self.items insertObject:cb3 atIndex:0];
  [self.items insertObject:cb0 atIndex:0];
  
  self.isContentHeaderAdded = true;
}


#pragma mark - Setters

- (void)setContent:(XMMContent *)content {
  _content = content;
  [self contentBlocksFromContent];
  
  [self.tableView reloadData];
  [self.tableView setNeedsLayout];
  [self.tableView layoutIfNeeded];
  [self.tableView reloadData];
}

- (void)setLinkColor:(UIColor *)linkColor {
  _linkColor = linkColor;
  [XMMContentBlock0TableViewCell setLinkColor:self.linkColor];
  [XMMContentBlock9TableViewCell setLinkColor: self.linkColor];
}

#pragma mark - Custom Methods

- (void)updateFontSizeTo:(TextFontSize)newFontSize {
  [XMMContentBlock0TableViewCell setFontSize:newFontSize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self.items objectAtIndex:indexPath.row];
  return [object tableView:tableView representationAsCellForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(didClickContentBlock:)]) {
      [self.delegate didClickContentBlock:cell.contentId];
    }
    //TODO didClick with cell.contentId
  }
}


@end
