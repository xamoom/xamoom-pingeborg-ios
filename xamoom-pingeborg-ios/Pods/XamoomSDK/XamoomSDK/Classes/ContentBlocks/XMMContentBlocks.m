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

#import "XMMContentBlocks.h"
#import <SDWebImage/UIImageView+WebCache.h>

int const kHorizontalSpaceToSubview = 32;
NSString* const kContentBlock9MapContentLinkNotification = @"com.xamoom.kContentBlock9MapContentLinkNotification";

#pragma mark - XMMContentBlocks Interface

@interface XMMContentBlocks ()

@end

#pragma mark - XMMContentBlocks Implementation

@implementation XMMContentBlocks

- (instancetype)initWithTableView:(UITableView *)tableView api:(XMMEnduserApi *)api {
  self = [super init];
  
  if (self) {
    self.api = api;
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupTableView];
    [self defaultStyle];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:self.style.backgroundColor];
    
    [XMMContentBlock0TableViewCell setFontSize:NormalFontSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickContentNotification:)
                                                 name:kContentBlock9MapContentLinkNotification
                                               object:nil];
  }
  
  return self;
}

- (void)viewWillDisappear {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseAllSounds" object:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView {
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 20.0;
  
  [self registerNibs];
}

- (void)defaultStyle {
  _style = [[XMMStyle alloc] init];
  self.style.backgroundColor = @"#FFFFFF";
  self.style.highlightFontColor = @"#0000FF";
  self.style.foregroundFontColor = @"#000000";
}

- (void)registerNibs {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  
  UINib *nib = [UINib nibWithNibName:@"XMMContentBlock0TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock0TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock1TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock1TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock2TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock2TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock3TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock3TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock4TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock4TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock5TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock5TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock6TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock6TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock7TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock7TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock8TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock8TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock9TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock9TableViewCell"];
}

- (void)displayContent:(XMMContent *)content {
  [self displayContent:content addHeader:YES];
}

- (void)displayContent:(XMMContent *)content addHeader:(Boolean)addHeader {
  if (addHeader) {
    self.items = [self addContentHeader:content];
  } else {
    self.items = [content.contentBlocks mutableCopy];
  }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}


#pragma mark - Setters

- (void)setStyle:(XMMStyle *)style {
  _style = style;
  self.tableView.backgroundColor = [UIColor colorWithHexString:style.backgroundColor];
}

#pragma mark - Getters

+ (NSString *)kContentBlock9MapContentLinkNotification {
  return kContentBlock9MapContentLinkNotification;
}

#pragma mark - Custom Methods

- (NSMutableArray *)addContentHeader:(XMMContent *)content {
  NSMutableArray *contentBlocks = [content.contentBlocks mutableCopy];
  
  XMMContentBlock *title = [[XMMContentBlock alloc] init];
  title.publicStatus = YES;
  title.blockType = 0;
  title.title = content.title;
  title.text = content.contentDescription;
  [contentBlocks insertObject:title atIndex:0];
  
  if (content.imagePublicUrl != nil && ![content.imagePublicUrl isEqualToString:@""]) {
    XMMContentBlock *image = [[XMMContentBlock alloc] init];
    image.publicStatus = YES;
    image.blockType = 3;
    image.fileID = content.imagePublicUrl;
    [contentBlocks insertObject:image atIndex:1];
  }
  
  return contentBlocks;
}

- (void)updateFontSizeTo:(TextFontSize)newFontSize {
  [XMMContentBlock0TableViewCell setFontSize:newFontSize];
  [self.tableView reloadData];
}

- (void)clickContentNotification:(NSNotification *)notification {
  if ([notification.name isEqualToString:kContentBlock9MapContentLinkNotification]) {
    NSDictionary *userInfo = notification.userInfo;
    NSString *contentID = [userInfo objectForKey:@"contentID"];
    [self.delegate didClickContentBlock:contentID];
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XMMContentBlock *block = [self.items objectAtIndex:indexPath.row];
  NSString *reuseIdentifier = [NSString stringWithFormat:@"XMMContentBlock%dTableViewCell", block.blockType];
  
  id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell) {
    UITableViewCell *tableViewCell = (UITableViewCell *)cell;
    tableViewCell.backgroundColor = [UIColor colorWithHexString:self.style.backgroundColor];
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style];
    return cell;
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:api:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style api:self.api];
    return cell;
  }
  
  return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  id cell = [tableView cellForRowAtIndexPath:indexPath];
  if ([cell isKindOfClass:[XMMContentBlock2TableViewCell class]]) {
    XMMContentBlock2TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell openVideo];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock6TableViewCell class]]) {
    XMMContentBlock6TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didClickContentBlock:cell.contentID];
  }
  
  if ([cell isKindOfClass:[XMMContentBlock3TableViewCell class]] || [cell isKindOfClass:[XMMContentBlock4TableViewCell class]] || [cell isKindOfClass:[XMMContentBlock8TableViewCell class]]) {
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell openLink];
  }
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

@end
