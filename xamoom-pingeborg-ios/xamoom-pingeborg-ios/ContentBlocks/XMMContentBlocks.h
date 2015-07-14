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

extern int const kHorizontalSpaceToSubview;

typedef NS_OPTIONS(NSInteger, TextFontSize)
{
  NormalFontSize = 12,
  BigFontSize = 15,
  BiggerFontSize = 18,
};

#pragma mark - XMMContentBlocksDelegate

@protocol XMMContentBlocksDelegate <NSObject>

- (void)reloadTableViewForContentBlocks;

@end

#pragma mark - XMMContentBlocks

@interface XMMContentBlocks : NSObject

@property (nonatomic, weak) id<XMMContentBlocksDelegate> delegate;
@property NSMutableArray *itemsToDisplay;
@property float screenWidth;
@property UIColor *linkColor;
@property NSString *language;

- (instancetype)init;

- (instancetype)initWithLanguage:(NSString*)language withWidth:(float)screenWidth;

- (void)displayContentBlocksByIdResult:(XMMResponseGetById *)idResult;

- (void)displayContentBlocksByLocationIdentifierResult:(XMMResponseGetByLocationIdentifier *)locationIdentifierResult;

- (void)displayContentBlock0:(XMMResponseContentBlockType0 *)contentBlock;

- (void)displayContentBlock1:(XMMResponseContentBlockType1 *)contentBlock;

- (void)displayContentBlock2:(XMMResponseContentBlockType2 *)contentBlock;

- (void)displayContentBlock3:(XMMResponseContentBlockType3 *)contentBlock;

- (void)displayContentBlock4:(XMMResponseContentBlockType4 *)contentBlock;

- (void)displayContentBlock5:(XMMResponseContentBlockType5 *)contentBlock;

- (void)displayContentBlock6:(XMMResponseContentBlockType6 *)contentBlock;

- (void)displayContentBlock7:(XMMResponseContentBlockType7 *)contentBlock;

- (void)displayContentBlock8:(XMMResponseContentBlockType8 *)contentBlock;

- (void)displayContentBlock9:(XMMResponseContentBlockType9 *)contentBlock;

- (void)updateFontSizeTo:(TextFontSize)newFontSize;

@end