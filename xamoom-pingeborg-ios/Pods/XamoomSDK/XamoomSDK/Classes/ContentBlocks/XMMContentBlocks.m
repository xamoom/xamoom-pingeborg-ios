//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlocks.h"
#import <SDWebImage/UIImageView+WebCache.h>

int const kHorizontalSpaceToSubview = 32;
NSString* const kContentBlock9MapContentLinkNotification = @"com.xamoom.ios.kContentBlock9MapContentLinkNotification";

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
    self.showAllStoreLinks = NO;
    self.showAllBlocksWhenOffline = NO;
    
    [self setupTableView];
    [self defaultStyle];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:self.style.backgroundColor];
    
    [XMMContentBlock0TableViewCell setFontSize:NormalFontSize];
    [XMMContentBlock100TableViewCell setFontSize:NormalFontSize + 1];
  }
  
  return self;
}

- (void)viewWillAppear {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(clickContentNotification:)
                                               name:kContentBlock9MapContentLinkNotification
                                             object:nil];
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
  NSBundle *bundle = [NSBundle bundleForClass:[XMMContentBlocks class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *nibBundle;
  if (url) {
    nibBundle = [NSBundle bundleWithURL:url];
  } else {
    nibBundle = bundle;
  }
  
  UINib *nib = [UINib nibWithNibName:@"XMMContentBlock100TableViewCell" bundle:nibBundle];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"XMMContentBlock100TableViewCell"];
  
  nib = [UINib nibWithNibName:@"XMMContentBlock0TableViewCell" bundle:nibBundle];
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
  
  if (!self.showAllStoreLinks) {
    self.items = [self removeStoreLinkBlocks:self.items];
  }
  
  if (!self.showAllBlocksWhenOffline && self.offline) {
    self.items = [self removeNonOfflineBlocks:self.items];
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
  title.blockType = 100;
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

- (NSMutableArray *)removeStoreLinkBlocks:(NSMutableArray *)blocks {
  NSMutableArray *deleteBlocks = [[NSMutableArray alloc] init];
  for (XMMContentBlock *block in blocks) {
    if ((block.blockType == 4) && (block.linkType == 17 || block.linkType == 16)) {
      [deleteBlocks addObject:block];
    }
  }
  [blocks removeObjectsInArray:deleteBlocks];
  return blocks;
}

- (NSMutableArray *)removeNonOfflineBlocks:(NSMutableArray *)blocks {
  NSMutableArray *deleteBlocks = [[NSMutableArray alloc] init];
  for (XMMContentBlock *block in blocks) {
    if (block.blockType == 7) {
      [deleteBlocks addObject:block];
    }
    
    if (block.blockType == 9) {
      [deleteBlocks addObject:block];
    }
    
    if (block.blockType == 2) {
      if ([block.videoUrl containsString:@"youtu"]) {
        [deleteBlocks addObject:block];
      }
      
      if ([block.videoUrl containsString:@"vimeo"]) {
        [deleteBlocks addObject:block];
      }
    }
  }
  
  [blocks removeObjectsInArray:deleteBlocks];
  return blocks;
}

- (void)updateFontSizeTo:(TextFontSize)newFontSize {
  [XMMContentBlock0TableViewCell setFontSize:newFontSize];
  [XMMContentBlock100TableViewCell setFontSize:newFontSize + 1];
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
  
  id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
  if (cell) {
    UITableViewCell *tableViewCell = (UITableViewCell *)cell;
    tableViewCell.backgroundColor = [UIColor clearColor];
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:offline:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style offline:self.offline];
    return cell;
  }
  
  if ([cell respondsToSelector:@selector(configureForCell:tableView:indexPath:style:api:offline:)]) {
    [cell configureForCell:block tableView:tableView indexPath:indexPath style:self.style api:self.api offline:self.offline];
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
