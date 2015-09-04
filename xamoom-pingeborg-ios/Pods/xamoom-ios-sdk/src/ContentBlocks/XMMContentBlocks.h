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
  NormalFontSize = 12,
  /**
   * BigFontSize is the next "bigger" fontSize.
   */
  BigFontSize = 15,
  /**
   * BiggerFontSize is the "biggest" fontSize.
   */
  BiggerFontSize = 18,
};

#pragma mark - XMMContentBlocksDelegate

@protocol XMMContentBlocksDelegate <NSObject>

/**
 * Needed to reload the tableView from XMMContentBlocks.
 */
- (void)reloadTableViewForContentBlocks;

@end

#pragma mark - XMMContentBlocks

/**
 * Use XMMContentBlocks to display all our contentBlocks from xamoom cloud.
 */
@interface XMMContentBlocks : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id<XMMContentBlocksDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *itemsToDisplay;
@property (nonatomic) float screenWidth;
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) NSString *language;
@property (nonatomic) BOOL showAllStoreLinks;

/**
 * Initializes the XMMContentBlock.
 *
 * @param language The preferred language, can be @"" for systemLanguage
 * @param screenWidth The width of the screen
 */
- (instancetype)initWithLanguage:(NSString*)language withWidth:(float)screenWidth;

/**
 * Generates tableViewCells to display a XMMContentById object.
 *
 * @param idResult A XMMContentById object that should be displayed.
 */
- (void)displayContentBlocksWithIdResult:(XMMContentById *)idResult;

/**
 * Generates tableViewCells to display a XMMContentLocationIdentifier object.
 *
 * @param locationIdentifierResult A XMMContentByLocationIdentifier object that should be displayed.
 */
- (void)displayContentBlocksWithLocationIdentifierResult:(XMMContentByLocationIdentifier *)locationIdentifierResult;

/**
 * Generates tableViewCells to display a XMMContent.
 *
 * @param content XMMContent to display.
 */
- (void)displayContentBlocksWith:(XMMContent *)content;

/**
 * Display the text contentBlock.
 *
 * @param contentBlock A XMMContentBlockType0 object
 */
- (void)displayContentBlock0:(XMMContentBlockType0 *)contentBlock addTitleFontOffset:(int)titleFontOffset;

/**
 * Display the audio contentBlock.
 *
 * @param contentBlock A XMMContentBlockType1 object
 */
- (void)displayContentBlock1:(XMMContentBlockType1 *)contentBlock;

/**
 * Display the video contentBlock.
 *
 * @param contentBlock A XMMContentBlockType2 object
 */
- (void)displayContentBlock2:(XMMContentBlockType2 *)contentBlock;

/**
 * Display the image contentBlock.
 *
 * @param contentBlock A XMMContentBlockType3 object
 */
- (void)displayContentBlock3:(XMMContentBlockType3 *)contentBlock;

/**
 * Display the link contentBlock.
 *
 * @param contentBlock A XMMContentBlockType4 object
 */
- (void)displayContentBlock4:(XMMContentBlockType4 *)contentBlock;

/**
 * Display the ebook contentBlock.
 *
 * @param contentBlock A XMMContentBlockType5 object
 */
- (void)displayContentBlock5:(XMMContentBlockType5 *)contentBlock;

/**
 * Display the content contentBlock.
 *
 * @param contentBlock A XMMContentBlockType6 object
 */
- (void)displayContentBlock6:(XMMContentBlockType6 *)contentBlock;

/**
 * Display the soundcloud contentBlock.
 *
 * @param contentBlock A XMMContentBlockType7 object
 */
- (void)displayContentBlock7:(XMMContentBlockType7 *)contentBlock;

/**
 * Display the download contentBlock.
 *
 * @param contentBlock A XMMContentBlockType8 object
 */
- (void)displayContentBlock8:(XMMContentBlockType8 *)contentBlock;

/**
 * Display the spotMap contentBlock.
 *
 * @param contentBlock A XMMContentBlockType9 object
 */
- (void)displayContentBlock9:(XMMContentBlockType9 *)contentBlock;

/**
 * Can be used to change the fontSize of the text contentBlock
 * for better readability.
 *
 * @param newFontSize New fontSize of the text contentBlock
 */
- (void)updateFontSizeTo:(TextFontSize)newFontSize;

@end