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

#import <Foundation/Foundation.h>
#import "TextBlockTableViewCell.h"
#import "AudioBlockTableViewCell.h"
#import "YoutubeBlockTableViewCell.h"
#import "ImageBlockTableViewCell.h"
#import "LinkBlockTableViewCell.h"
#import "EbookBlockTableViewCell.h"
#import "ContentBlockTableViewCell.h"
#import "SoundcloudBlockTableViewCell.h"
#import "DownloadBlockTableViewCell.h"
#import "SpotMapBlockTableViewCell.h"
#import "UIImage+animatedGIF.h"
#import "SVGKit.h"

extern int const kHorizontalSpaceToSubview;

/**
 Declaring different TextFontSizes.
 Can be used to provide 3 different fontSizes for
 the XMMContentBlocks.
 */
typedef NS_OPTIONS(NSInteger, TextFontSize) {
  /**
   NormalFontSize is the "standard" fontSize.
   */
  NormalFontSize = 12,
  /**
   BigFontSize is the next "bigger" fontSize.
   */
  BigFontSize = 15,
  /**
   BiggerFontSize is the "biggest" fontSize.
   */
  BiggerFontSize = 18,
};

#pragma mark - XMMContentBlocksDelegate

/**
 */
@protocol XMMContentBlocksDelegate <NSObject>

/**
 */
- (void)reloadTableViewForContentBlocks;

@end

#pragma mark - XMMContentBlocks

/**
 */
@interface XMMContentBlocks : NSObject <UIWebViewDelegate>

@property (nonatomic, weak) id<XMMContentBlocksDelegate> delegate;
@property NSMutableArray *itemsToDisplay;
@property float screenWidth;
@property UIColor *linkColor;
@property NSString *language;

/**
 Initializes the XMMContentBlock.
 
 @param language The preferred language, can be @"" for systemLanguage
 @param screenWidth The width of the screen
*/
- (instancetype)initWithLanguage:(NSString*)language withWidth:(float)screenWidth;

/**
 Generates tableViewCells to display a XMMResponseGetById object.
 
 @param idResult A XMMResponseGetById object that should be displayed.
 */
- (void)displayContentBlocksByIdResult:(XMMResponseGetById *)idResult;

/**
 Generates tableViewCells to display a XMMResponseGetByLocationIdentifier object.
 
 @param locationIdentifierResult A XMMResponseGetByLocationIdentifier object that should be displayed.
 */
- (void)displayContentBlocksByLocationIdentifierResult:(XMMResponseGetByLocationIdentifier *)locationIdentifierResult;

/**
 Display the text contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType0 object
 */
- (void)displayContentBlock0:(XMMResponseContentBlockType0 *)contentBlock;

/**
 Display the audio contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType1 object
 */
- (void)displayContentBlock1:(XMMResponseContentBlockType1 *)contentBlock;

/**
 Display the youtube contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType2 object
*/
- (void)displayContentBlock2:(XMMResponseContentBlockType2 *)contentBlock;

/**
 Display the image contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType3 object
*/
- (void)displayContentBlock3:(XMMResponseContentBlockType3 *)contentBlock;

/**
 Display the link contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType4 object
*/
- (void)displayContentBlock4:(XMMResponseContentBlockType4 *)contentBlock;

/**
 Display the ebook contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType5 object
*/
- (void)displayContentBlock5:(XMMResponseContentBlockType5 *)contentBlock;

/**
 Display the content contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType6 object
*/
- (void)displayContentBlock6:(XMMResponseContentBlockType6 *)contentBlock;

/**
 Display the soundcloud contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType7 object
*/
- (void)displayContentBlock7:(XMMResponseContentBlockType7 *)contentBlock;

/**
 Display the download contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType8 object
*/
- (void)displayContentBlock8:(XMMResponseContentBlockType8 *)contentBlock;

/**
 Display the spotMap contentBlock.
 
 @param contentBlock A XMMResponseContentBlockType9 object
*/
- (void)displayContentBlock9:(XMMResponseContentBlockType9 *)contentBlock;

/**
 Can be used to change the fontSize of the text contentBlock
 for better readability.
 
 @param newFontSize New fontSize of the text contentBlock
 */
- (void)updateFontSizeTo:(TextFontSize)newFontSize;

@end