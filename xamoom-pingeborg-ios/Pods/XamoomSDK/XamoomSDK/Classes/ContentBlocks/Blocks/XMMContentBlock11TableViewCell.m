//
//  XMMContentBlock11TableViewCell.m
//  XamoomSDK
//
//  Created by Raphael Seher on 04/10/2017.
//  Copyright © 2017 xamoom GmbH. All rights reserved.
//

#import "XMMContentBlock11TableViewCell.h"
#import "XMMContentBlocks.h"
#import "XMMListManager.h"

@interface XMMContentBlock11TableViewCell()

@property (nonatomic, strong) UITableView *parentTableView;
@property (nonatomic, strong) XMMListManager *listManager;
@property (nonatomic, strong) NSIndexPath *parentIndexPath;
@property (nonatomic, strong) XMMContentBlocks *contentBlocks;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadMoreButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loadMoreButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (nonatomic, strong) NSBundle *bundle;

@end

@implementation XMMContentBlock11TableViewCell

int tableViewTopConstant = 8;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url != nil) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
  
  _tableView.contentInset = UIEdgeInsetsMake(-16, 0, 0, 0);
  _tableView.scrollEnabled = NO;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [_loadMoreButton setTitle:NSLocalizedStringFromTableInBundle(@"Load more", @"Localizable", _bundle, nil)
                   forState:UIControlStateNormal];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _titleLabel.text = nil;
  _loadMoreButtonTopConstraint.constant = 8;
  _loadMoreButtonHeightConstraint.constant = 39;
  _tableViewTopConstraint.constant = tableViewTopConstant;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style api:(XMMEnduserApi *)api listManager:(XMMListManager *)listManager offline:(BOOL)offline delegate:(id)delegate {
  _listManager = listManager;
  _listManager.api.offline = offline;
  _parentTableView = tableView;
  _parentIndexPath = indexPath;
  
  if (_contentBlocks == nil) {
    _contentBlocks = [[XMMContentBlocks alloc] initWithTableView:_tableView api:api];
    _contentBlocks.delegate = delegate;
    _contentBlocks.offline = offline;
    _contentBlocks.style = style;
  }
  
  if (block.title != nil && ![block.title isEqualToString:@""]) {
    _titleLabel.text = block.title;
  } else {
    _tableViewTopConstraint.constant = 0;
    [self setNeedsUpdateConstraints];
  }
  
  _loadMoreButton.hidden = YES;
  [self showLoading];
  
  XMMListItem *listItem = [listManager listItemFor: (int)indexPath.row];
  if (listItem != nil && listItem.contents.count > 0) {
    _activityIndicator.hidden = YES;
    if (listItem.hasMore) {
      _loadMoreButton.hidden = NO;
    } else {
      [self hideLoadMoreButtonWithConstraints];
    }
    
    _tableViewHeightConstraint.constant = 89 * listItem.contents.count;
    [self setNeedsLayout];
    
    [_contentBlocks displayContent: [self generateContentsFrom:listItem.contents]];
  } else {
    [self loadContentWith:block.contentListTags pageSize:block.contentListPageSize ascending:block.contentListSortAsc position:(int)indexPath.row];
  }
}

- (IBAction)didClickLoadMore:(id)sender {
  [self showLoading];
  
  XMMListItem *listItem = [_listManager listItemFor: (int)_parentIndexPath.row];
  [self loadContentWith:listItem.tags pageSize:listItem.pageSize ascending:listItem.sortAsc position:(int)_parentIndexPath.row];
}

- (void)loadContentWith:(NSArray *)tags pageSize:(int)pageSize ascending:(Boolean)ascending position:(int)position {
  [_listManager downloadContentsWith:tags pageSize:pageSize ascending:ascending position:(int)position callback:^(NSArray *contents, bool hasMore, int position, NSError *error) {
    _activityIndicator.hidden = YES;
    
    if (error != nil) {
      [self hideLoadMoreButtonWithConstraints];
      return;
    }
    
    if (hasMore) {
      _loadMoreButton.hidden = NO;
    } else {
      [self hideLoadMoreButtonWithConstraints];
    }
    
    _tableViewHeightConstraint.constant = 89 * contents.count;
    [self setNeedsLayout];
    
    [_contentBlocks displayContent: [self generateContentsFrom:contents]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:position inSection:0];
    [_parentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
  }];
}

- (void)showLoading {
  _loadMoreButton.hidden = YES;
  _activityIndicator.hidden = NO;
  [_activityIndicator startAnimating];
}

- (void)hideLoadMoreButtonWithConstraints {
  _loadMoreButton.hidden = YES;
  _loadMoreButtonTopConstraint.constant = 0;
  _loadMoreButtonHeightConstraint.constant = 0;
  
  [self setNeedsLayout];
}

- (XMMContent *)generateContentsFrom:(NSArray *)contents {
  NSMutableArray *contentBlocks = [[NSMutableArray alloc] init];
  for (XMMContent *content in contents) {
    XMMContentBlock *block = [[XMMContentBlock alloc] init];
    block.contentID = content.ID;
    block.blockType = 6;
    [contentBlocks addObject:block];
  }
  
  XMMContent *content = [[XMMContent alloc] init];
  content.contentBlocks = contentBlocks;
  
  return content;
}

@end
