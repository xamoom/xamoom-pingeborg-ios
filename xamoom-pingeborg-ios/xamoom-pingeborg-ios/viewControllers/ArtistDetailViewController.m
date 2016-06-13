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
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import "ArtistDetailViewController.h"

static int kHeaderViewHeight = 200;

@interface ArtistDetailViewController()

@property UIView *headerView;

@property JGProgressHUD *hud;
@property REMenu *fontSizeDropdownMenu;

@property XMMContent *savedResult;
@property XMMContentBlocks *contentBlocks;

@property CALayer *headerImageViewOverlay;
@property double topBarOffset;
@property double verticalVelocity;

@end

@implementation ArtistDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //analytics
  [[Analytics sharedObject] setScreenName:@"Artist Detail"];
    
  self.hud = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
  [self hideNavigationBar];
  
  //setup
  self.topBarOffset = [[UIApplication sharedApplication] statusBarFrame].size.height + (double)self.navigationController.navigationBar.frame.size.height;
  
  [self setupContentBlocks];
  [self setupTableView];
  [self setupTextSizeDropdown];
  [self setupHeaderView];
  [self downloadContent];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.headerView = self.tableView.tableHeaderView;
  self.tableView.tableHeaderView = nil;
  [self.tableView addSubview:self.headerView];
  
  self.tableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
  self.tableView.contentOffset = CGPointMake(0, -kHeaderViewHeight);
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.contentBlocks viewWillDisappear];
  [self showNavigationBar];
}

#pragma mark - Setup

- (void)setupTableView {
  self.tableView.dataSource = self.contentBlocks;
  self.tableView.delegate = self;
}

- (void)setupTextSizeDropdown {
  //dropdown menu
  REMenuItem *NormalFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Normal Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Normal Font Size" andValue:nil];
                                                                [self.contentBlocks updateFontSizeTo:NormalFontSize];
                                                                [self.tableView reloadData];
                                                              }];
  
  REMenuItem *BigFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Big Font Size", nil)
                                                         subtitle:nil
                                                            image:nil
                                                 highlightedImage:nil
                                                           action:^(REMenuItem *item) {
                                                             [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Big Font Size" andValue:nil];
                                                             [self.contentBlocks updateFontSizeTo:BigFontSize];
                                                             [self.tableView reloadData];
                                                           }];
  
  REMenuItem *BiggerFontSizeItem = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"Really Big Font Size", nil)
                                                            subtitle:nil
                                                               image:nil
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Changed Fontsize" andLabel:@"Really Big Font Size" andValue:nil];
                                                                [self.contentBlocks updateFontSizeTo:BiggerFontSize];
                                                                [self.tableView reloadData];
                                                              }];
  
  self.fontSizeDropdownMenu = [[REMenu alloc] initWithItems:@[NormalFontSizeItem, BigFontSizeItem, BiggerFontSizeItem]];
  self.fontSizeDropdownMenu.textColor = [UIColor whiteColor];
  
  //create changeFontSize button
  UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"textsize"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(toggleFontSizeDropdownMenu)];
  self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)setupContentBlocks {
  self.contentBlocks = [[XMMContentBlocks alloc] initWithTableView:self.tableView api:[XMMEnduserApi sharedInstance]];
  self.contentBlocks.delegate = self;
  self.contentBlocks.linkColor = [Globals sharedObject].pingeborgLinkColor;
}

- (void)setupHeaderView {
  self.headerImageViewOverlay = [CALayer layer];
  self.headerImageViewOverlay.frame = self.headerImageView.bounds;
  self.headerImageViewOverlay.backgroundColor = [[Globals sharedObject].pingeborgYellow CGColor];
  self.headerImageViewOverlay.opacity = 0.0f;
  [self.headerImageView.layer insertSublayer:self.headerImageViewOverlay atIndex:0];
  
  
  self.headerImageGradientView = [[GradientBackgroundView alloc] initWithFrame:
                                  CGRectMake(0,
                                             0,
                                             self.headerImageView.frame.size.width,
                                             100)];
  [self.headerImageView addSubview:self.headerImageGradientView];
  self.headerImageGradientView.firstColor = [UIColor blackColor];
  self.headerImageGradientView.secondColor = [UIColor clearColor];
  self.headerImageGradientView.opacity = 0.3f;
}

- (void)downloadContent {
  [self.hud showInView:self.view];

  NSString* savedArtists = [[Globals sharedObject] savedArtits];
  if ([savedArtists containsString:self.contentId]) {
    
    [[XMMEnduserApi sharedInstance] contentWithID:self.contentId completion:^(XMMContent *content, NSError *error) {
      [self showDataWithContentId:content];
    }];
  } else {
    [[XMMEnduserApi sharedInstance] contentWithID:self.contentId options:XMMContentOptionsPrivate completion:^(XMMContent *content, NSError *error) {
      [self showDataWithContentId:content];
    }];
  }
}

- (void)showDataWithContentId:(XMMContent *)result {
  //analytics
  [[Analytics sharedObject] sendEventWithCategorie:@"pingeb.org" andAction:@"Show content" andLabel:result.ID andValue:nil];
  
  [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:result.imagePublicUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
  
  XMMContentBlock *titleBlock = [[XMMContentBlock alloc] init];
  titleBlock.blockType = 0;
  titleBlock.title = result.title;
  titleBlock.text = result.contentDescription;
  
  NSMutableArray *blocks = [result.contentBlocks mutableCopy];
  [blocks insertObject:titleBlock atIndex:0];
  result.contentBlocks = blocks;
  
  self.savedResult = result;
  [self.contentBlocks displayContent:result addHeader:NO];
  [self.hud dismiss];
}

- (void)hideNavigationBar {
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
}

- (void)showNavigationBar {
  self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  
  [self.navigationController.navigationBar setBackgroundImage:nil
                                                forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  self.navigationController.navigationBar.translucent = NO;
}

- (void)updateHeaderView {
  CGRect headerRect = CGRectMake(0, -kHeaderViewHeight, self.tableView.bounds.size.width, kHeaderViewHeight);
  if (self.tableView.contentOffset.y < -kHeaderViewHeight) {
    headerRect.origin.y = self.tableView.contentOffset.y;
    headerRect.size.height = -self.tableView.contentOffset.y;
  }
  
  if (self.tableView.contentOffset.y > -self.topBarOffset && self.navigationController.navigationBar.translucent) {
    self.tableView.contentOffset = CGPointMake(0, 0);
    [self showNavigationBar];
  } else if (self.tableView.contentOffset.y < 0 && !self.navigationController.navigationBar.translucent) {
    self.tableView.contentOffset = CGPointMake(0, -self.topBarOffset);
    [self hideNavigationBar];
  }
  
  if (self.tableView.contentOffset.y < 0) {
    if (self.verticalVelocity > 0) {
      self.headerImageViewOverlay.opacity = (1-((-self.tableView.contentOffset.y - self.topBarOffset)/136) - self.verticalVelocity/2);
    } else if (self.verticalVelocity < 0) {
      self.headerImageViewOverlay.opacity = (1-((-self.tableView.contentOffset.y - self.topBarOffset)/136) + self.verticalVelocity/2);
    } else {
      self.headerImageViewOverlay.opacity = (1-((-self.tableView.contentOffset.y - self.topBarOffset)/136));
    }
  } else {
    self.headerImageViewOverlay.opacity = 0.0f;
  }
  
  self.headerView.frame = headerRect;
}

#pragma mark - NavbarDropdown

- (void)toggleFontSizeDropdownMenu {
  if (self.fontSizeDropdownMenu.isOpen)
    return [self.fontSizeDropdownMenu close];
  
  [[Analytics sharedObject] sendEventWithCategorie:@"UX" andAction:@"Click" andLabel:@"FontSizeMenu" andValue:nil];
  [self.fontSizeDropdownMenu showFromNavigationController:self.navigationController];
}

#pragma mark - XMMContentBlock Delegate

- (void)didClickContentBlock:(NSString *)contentId {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  ArtistDetailViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailView"];
  
  [[Globals sharedObject] addDiscoveredArtist:contentId];
  [vc setContentId:contentId];
  [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.contentBlocks tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [self updateHeaderView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
  NSLog(@"Veloctiy: %f", velocity.y);
  self.verticalVelocity = velocity.y;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  self.verticalVelocity = 0;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 NSLog(@"prepareForSegue");
 UIViewController *vc = [segue destinationViewController];
 }
 */

@end
