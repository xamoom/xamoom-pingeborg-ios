//
//  XMMContentBlocks.h
//  XMMContentBlocks
//
//  Created by Raphael Seher on 12.05.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for XMMContentBlocks.
FOUNDATION_EXPORT double XMMContentBlocksVersionNumber;

//! Project version string for XMMContentBlocks.
FOUNDATION_EXPORT const unsigned char XMMContentBlocksVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <XMMContentBlocks/PublicHeader.h>


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
  NormalFontSize = 17,
  BigFontSize = 21,
  BiggerFontSize = 25,
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


- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (void)displayContentBlocksById:(XMMResponseGetById *)IdResult byLocationIdentifier:(XMMResponseGetByLocationIdentifier *)LocationIdentifierResult withScreenWidth:(float)screenWidth;

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

- (void)updateFontSizeOnTextTo:(TextFontSize)newFontSize;

@end