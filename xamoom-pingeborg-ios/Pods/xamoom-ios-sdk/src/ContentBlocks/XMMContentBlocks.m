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

@property (nonatomic) int fontSize;

@end

#pragma mark - XMMContentBlocks Implementation

@implementation XMMContentBlocks

- (instancetype)initWithLanguage:(NSString*)language withWidth:(float)screenWidth {
  self = [super init];
  
  if(self) {
    self.itemsToDisplay = [[NSMutableArray alloc] init];
    self.fontSize = NormalFontSize;
    self.linkColor = [UIColor blueColor];
    self.language = language;
    self.screenWidth = screenWidth - kHorizontalSpaceToSubview;
    self.showAllStoreLinks = NO;
  }
  
  //notification to reload delegates tableview from special contentBlockCells
  NSString *notificationName = @"reloadTableViewForContentBlocks";
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadTableView)
                                               name:notificationName
                                             object:nil];
  
  return self;
}

# pragma mark - ContentBlock Methods

- (void)displayContentBlocksWithIdResult:(XMMContentById *)idResult {
  if (idResult == nil) {
    return;
  }
  
  [self addContentBlockHeader:idResult.content.title
                   andExcerpt:idResult.content.descriptionOfContent
            andImagePublicUrl:idResult.content.imagePublicUrl];
  [self generateTableViewCellsWithContentBlocks:idResult.content.contentBlocks];
}

- (void)displayContentBlocksWithLocationIdentifierResult:(XMMContentByLocationIdentifier *)locationIdentifierResult {
  if (locationIdentifierResult == nil) {
    return;
  }
  
  [self addContentBlockHeader:locationIdentifierResult.content.title
                   andExcerpt:locationIdentifierResult.content.descriptionOfContent
            andImagePublicUrl:locationIdentifierResult.content.imagePublicUrl];
  [self generateTableViewCellsWithContentBlocks:locationIdentifierResult.content.contentBlocks];
}

- (void)displayContentBlocksWith:(XMMContent *)content {
  if (content == nil) {
    return;
  }
  
  [self addContentBlockHeader:content.title
                   andExcerpt:content.descriptionOfContent
            andImagePublicUrl:content.imagePublicUrl];
  [self generateTableViewCellsWithContentBlocks:content.contentBlocks];
}

- (void)addContentBlockHeader:(NSString*)title andExcerpt:(NSString*)excerpt andImagePublicUrl:(NSString*)imagePublicUrl {
  
  XMMContentBlockType0 *contentBlock0 = [[XMMContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = 0;
  contentBlock0.title = title;
  contentBlock0.text = excerpt;
  [self displayContentBlock0:contentBlock0 addTitleFontOffset:8];
  
  if (imagePublicUrl != nil && ![imagePublicUrl isEqualToString:@""]) {
    XMMContentBlockType3 *contentBlock3 = [[XMMContentBlockType3 alloc] init];
    contentBlock3.fileId = imagePublicUrl;
    [self displayContentBlock3:contentBlock3];
  }
}

- (void)generateTableViewCellsWithContentBlocks:(NSArray*)contentBlocks {
  for (XMMContentBlock *contentBlock in contentBlocks) {
    
    switch (contentBlock.contentBlockType) {
      case 0: {
        XMMContentBlockType0 *contentBlock0 = (XMMContentBlockType0*)contentBlock;
        [self displayContentBlock0:contentBlock0 addTitleFontOffset:0];
        break;
      }
      case 1: {
        XMMContentBlockType1 *contentBlock1 = (XMMContentBlockType1*)contentBlock;
        [self displayContentBlock1:contentBlock1];
        break;
      }
      case 2: {
        XMMContentBlockType2 *contentBlock2 = (XMMContentBlockType2*)contentBlock;
        [self displayContentBlock2:contentBlock2];
        break;
      }
      case 3: {
        XMMContentBlockType3 *contentBlock3 = (XMMContentBlockType3*)contentBlock;
        [self displayContentBlock3:contentBlock3];
        break;
      }
      case 4: {
        XMMContentBlockType4 *contentBlock4 = (XMMContentBlockType4*)contentBlock;
        [self displayContentBlock4:contentBlock4];
        break;
      }
      case 5: {
        XMMContentBlockType5 *contentBlock5 = (XMMContentBlockType5*)contentBlock;
        [self displayContentBlock5:contentBlock5];
        break;
      }
      case 6: {
        XMMContentBlockType6 *contentBlock6 = (XMMContentBlockType6*)contentBlock;
        [self displayContentBlock6:contentBlock6];
        break;
      }
      case 7: {
        XMMContentBlockType7 *contentBlock7 = (XMMContentBlockType7*)contentBlock;
        [self displayContentBlock7:contentBlock7];
        break;
      }
      case 8: {
        XMMContentBlockType8 *contentBlock8 = (XMMContentBlockType8*)contentBlock;
        [self displayContentBlock8:contentBlock8];
        break;
      }
      case 9: {
        XMMContentBlockType9 *contentBlock9 = (XMMContentBlockType9*)contentBlock;
        [self displayContentBlock9:contentBlock9];
        break;
      }
      default:
        break;
    }
  }
  
  [self reloadTableView];
}

#pragma mark - Display Content Blocks

#pragma mark Text Block
- (void)displayContentBlock0:(XMMContentBlockType0 *)contentBlock addTitleFontOffset:(int)titleFontOffset {
  XMMContentBlock0TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock0TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //save data for later use
  cell.titleText = contentBlock.title;
  cell.contentText = contentBlock.text;
  cell.contentBlockType = contentBlock.contentBlockType;
  
  //set title
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""]) {
    cell.titleLabel.text = contentBlock.title;
    [cell.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize+5+titleFontOffset]];
  }
  
  //set content
  if (contentBlock.text != nil && ![cell.contentText isEqualToString:@""]) {
    cell.contentTextView.attributedText = [self attributedStringFromHTML:contentBlock.text];
    [cell.contentTextView sizeToFit];
  } else {
    //make uitextview "disappear"
    [cell.contentTextView setFont:[UIFont systemFontOfSize:0.0f]];
    cell.contentTextView.textContainerInset = UIEdgeInsetsZero;
    cell.contentTextView.textContainer.lineFragmentPadding = 0;
  }
  
  //set the linkcolor to a specific color
  [cell.contentTextView setLinkTextAttributes:@{NSForegroundColorAttributeName : self.linkColor, }];
  
  //add to array
  [self.itemsToDisplay addObject: cell];
}

#pragma mark Audio Block
- (void)displayContentBlock1:(XMMContentBlockType1 *)contentBlock {
  XMMContentBlock1TableViewCell *cell;
  
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock1TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set audioPlayerControl delegate and initialize
  cell.audioPlayerControl.delegate = cell;
  [cell.audioPlayerControl initAudioPlayerWithUrlString:contentBlock.fileId];
  
  //set title & artist
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  if(contentBlock.artist != nil && ![contentBlock.artist isEqualToString:@""])
    cell.artistLabel.text = contentBlock.artist;
  
  //set songDuration
  float songDurationInSeconds = CMTimeGetSeconds(cell.audioPlayerControl.audioPlayer.currentItem.asset.duration);
  cell.remainingTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)songDurationInSeconds / 60, (int)songDurationInSeconds % 60];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Youtube Block
- (void)displayContentBlock2:(XMMContentBlockType2 *)contentBlock {
  XMMContentBlock2TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock2TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title and youtubeUrl
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  [cell initVideoWithUrl:contentBlock.videoUrl andWidth:self.screenWidth];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Image Block
- (void)displayContentBlock3:(XMMContentBlockType3 *)contentBlock {
  XMMContentBlock3TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock3TableViewCell" owner:self options:nil];
  cell = nib[0];
  cell.linkUrl = contentBlock.linkUrl;
  
  //set title
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  //scale the imageView
  float scalingFactor = 1;
  if (contentBlock.scaleX != nil) {
    scalingFactor = contentBlock.scaleX.floatValue / 100;
    float newImageWidth = self.screenWidth * scalingFactor;
    float sizeDiff = self.screenWidth - newImageWidth;
    
    cell.imageLeftHorizontalSpaceConstraint.constant = sizeDiff/2;
    cell.imageRightHorizontalSpaceConstraint.constant = (sizeDiff/2)*(-1);
  }
  
  if (contentBlock.fileId != nil) {
    [cell.imageLoadingIndicator startAnimating];

    if ([contentBlock.fileId containsString:@".svg"]) {
      SVGKImage* newImage;
      newImage = [SVGKImage imageWithContentsOfURL:[NSURL URLWithString:contentBlock.fileId]];
      cell.image.image = newImage.UIImage;
      
      NSLayoutConstraint *constraint =[NSLayoutConstraint
                                       constraintWithItem:cell.image
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:cell.image
                                       attribute:NSLayoutAttributeHeight
                                       multiplier:(newImage.size.width/newImage.size.height)
                                       constant:0.0f];
      [cell.image addConstraint:constraint];
      [cell needsUpdateConstraints];
      [cell.imageLoadingIndicator stopAnimating];
    } else {
      [cell.image sd_setImageWithURL:[NSURL URLWithString:contentBlock.fileId]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             NSLayoutConstraint *constraint =[NSLayoutConstraint
                                                              constraintWithItem:cell.image
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                              toItem:cell.image
                                                              attribute:NSLayoutAttributeHeight
                                                              multiplier:(image.size.width/image.size.height)
                                                              constant:0.0f];
                             
                             [cell.image addConstraint:constraint];
                             [cell needsUpdateConstraints];
                             [cell.imageLoadingIndicator stopAnimating];
                             [self reloadTableView];
                           }];
    }
  }
  
  [self.itemsToDisplay addObject:cell];
}


#pragma mark Link Block
- (void)displayContentBlock4:(XMMContentBlockType4 *)contentBlock {
  if (!self.showAllStoreLinks && (contentBlock.linkType == 16 || contentBlock.linkType == 17)) {
    return;
  }
  
  XMMContentBlock4TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock4TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, text, linkUrl and linkType
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  cell.linkTextLabel.text = contentBlock.text;
  cell.linkUrl = contentBlock.linkUrl;
  cell.linkType = contentBlock.linkType;
  
  //change style of the cell according to the linktype
  [cell changeStyleAccordingToLinkType];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Ebook Block
- (void)displayContentBlock5:(XMMContentBlockType5 *)contentBlock {
  XMMContentBlock5TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock5TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, artist and downloadUrl
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  cell.artistLabel.text = contentBlock.artist;
  cell.downloadUrl = contentBlock.fileId;
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Content Block
- (void)displayContentBlock6:(XMMContentBlockType6 *)contentBlock {
  XMMContentBlock6TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock6TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set content
  cell.contentId = contentBlock.contentId;
  
  //init contentBlock
  [cell initContentBlockWithLanguage:self.language];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Soundcloud Block
- (void)displayContentBlock7:(XMMContentBlockType7 *)contentBlock {
  XMMContentBlock7TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock7TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //disable scrolling and bouncing
  [cell.webView.scrollView setScrollEnabled:NO];
  [cell.webView.scrollView setBounces:NO];
  
  //set title
  cell.titleLabel.text = contentBlock.title;
  
  NSString *soundcloudHTML = [NSString stringWithFormat:@"<iframe width='100%%' height='%f' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=%@&auto_play=false&hide_related=true&show_comments=false&show_comments=false&show_user=false&show_reposts=false&sharing=false&download=false&buying=false&visual=true'></iframe> <script src=\"https://w.soundcloud.com/player/api.js\" type=\"text/javascript\"></script>",cell.webView.frame.size.height, contentBlock.soundcloudUrl];
  
  //display soundcloud in webview
  [cell.webView loadHTMLString:soundcloudHTML baseURL:nil];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Download Block
- (void)displayContentBlock8:(XMMContentBlockType8 *)contentBlock {
  XMMContentBlock8TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock8TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, text, fileId and downloadType
  cell.titleLabel.text = contentBlock.title;
  cell.contentTextLabel.text = contentBlock.text;
  cell.fileId = contentBlock.fileId;
  cell.downloadType = contentBlock.downloadType;
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark SpotMap Block
- (void)displayContentBlock9:(XMMContentBlockType9 *)contentBlock {
  XMMContentBlock9TableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XMMContentBlock9TableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, spotmapTags
  cell.titleLabel.text = contentBlock.title;
  cell.linkColor = self.linkColor;
  cell.spotMapTags = [contentBlock.spotMapTag componentsSeparatedByString:@","];
  [cell getSpotMapWithSystemId:0 withLanguage:self.language];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark - Custom Methods

- (void)reloadTableView {
  if ([self.delegate respondsToSelector:@selector(reloadTableViewForContentBlocks)]) {
    [self.delegate performSelector:@selector(reloadTableViewForContentBlocks)];
  }
}

- (NSMutableAttributedString*)attributedStringFromHTML:(NSString*)html {
  NSError *err = nil;
  
  NSString *style = [NSString stringWithFormat:@"<style>body{font-family: \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%dpt; margin:0 !important;} p:last-child, p:last-of-type{margin:1px !important;} </style>", self.fontSize];
  
  html = [html stringByReplacingOccurrencesOfString:@"<br></p>" withString:@"</p>"];
  html = [NSString stringWithFormat:@"%@%@", style, html];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData: [html dataUsingEncoding:NSUTF8StringEncoding]
                                                                                        options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                                    NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                             documentAttributes: nil
                                                                                          error: &err];
  if(err)
    NSLog(@"Unable to parse label text: %@", err);
  
  return attributedString;
}

- (void)updateFontSizeTo:(TextFontSize)newFontSize {
  if (self.fontSize == newFontSize) {
    return;
  }
  
  self.fontSize = newFontSize;
  
  //Change fontSize in textblocks
  for (XMMContentBlock *contentItem in self.itemsToDisplay) {
    if ([contentItem isKindOfClass:[XMMContentBlock0TableViewCell class]]) {
      XMMContentBlock0TableViewCell* textBlock = (XMMContentBlock0TableViewCell*)contentItem;
      textBlock.contentTextView.attributedText = [self attributedStringFromHTML:textBlock.contentText];
      [textBlock.titleLabel setFont:[UIFont boldSystemFontOfSize:self.fontSize+7]];
    }
  }
  
  [self reloadTableView];
}

@end
