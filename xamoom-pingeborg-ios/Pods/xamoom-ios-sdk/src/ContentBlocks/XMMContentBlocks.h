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

#import <Foundation/Foundation.h>
#import "XMMContentBlock0TableViewCell.h"
#import "XMMContentBlock1TableViewCell.h"
#import "XMMContentBlock2TableViewCell.h"
#import "XMMContentBlock3TableViewCell.h"
#import "XMMContentBlock4TableViewCell.h"
#import "XMMContentBlock5TableViewCell.h"
#import "XMMContentBlock6TableViewCell.h"
#import "XMMContentBlock7TableViewCell.h"
#import "XMMContentBlock8TableViewCell.h"
#import "XMMContentBlock9TableViewCell.h"
#import "UIImage+animatedGIF.h"
#import "SVGKit.h"

extern int const kHorizontalSpaceToSubview;

/**
 * Declaring different TextFontSizes.
 * Can be used to provide 3 different fontSizes for
 * the XMMContentBlocks.
 */
typedef NS_OPTIONS(NSInteger, TextFontSize) {
  /**
   * NormalFontSize is the "standard" fontSize.
   */
  NormalFontSize = 15,
  /**
   * BigFontSize is the next "bigger" fontSize.
   */
  BigFontSize = 18,
  /**
   * BiggerFontSize is the "biggest" fontSize.
   */
  BiggerFontSize = 20,
};

@protocol XMMContentBlocksDelegate <NSObject>

- (void)didClickContentBlock:(NSString *)contentId;

@end

#pragma mark - XMMContentBlocks

/**
 * Use XMMContentBlocks to display all our contentBlocks from xamoom cloud.
 */
@interface XMMContentBlocks : NSObject <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (nonatomic, retain) id<XMMContentBlocksDelegate> delegate;
@property (nonatomic, strong) XMMContent *content;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) NSString *language;
@property (nonatomic) BOOL showAllStoreLinks;

/**
 * Initializes the XMMContentBlock.
 *
 * @param language The preferred language, can be @"" for systemLanguage
 * @param screenWidth The width of the screen
 */
- (instancetype)initWithTableView:(UITableView *)tableView language:(NSString*)language;

/**
 * Can be used to change the fontSize of the text contentBlock
 * for better readability.
 *
 * @param newFontSize New fontSize of the text contentBlock
 */
- (void)updateFontSizeTo:(TextFontSize)newFontSize;

@end