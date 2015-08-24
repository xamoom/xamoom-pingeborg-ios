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

#import "XMMContentBlocks.h"
#import <SDWebImage/UIImageView+WebCache.h>

int const kHorizontalSpaceToSubview = 32;

#pragma mark - XMMContentBlocks Interface

@interface XMMContentBlocks ()

@property int fontSize;

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

- (void)displayContentBlocksByIdResult:(XMMResponseGetById *)idResult {
  if (idResult == nil) {
    return;
  }
  
  [self addContentBlockHeader:idResult.content.title
                   andExcerpt:idResult.content.descriptionOfContent
            andImagePublicUrl:idResult.content.imagePublicUrl];
  [self generateTableViewCellsWithContentBlocks:idResult.content.contentBlocks];
}

- (void)displayContentBlocksByLocationIdentifierResult:(XMMResponseGetByLocationIdentifier *)locationIdentifierResult {
  if (locationIdentifierResult == nil) {
    return;
  }
  
  [self addContentBlockHeader:locationIdentifierResult.content.title
                   andExcerpt:locationIdentifierResult.content.descriptionOfContent
            andImagePublicUrl:locationIdentifierResult.content.imagePublicUrl];
  [self generateTableViewCellsWithContentBlocks:locationIdentifierResult.content.contentBlocks];
}

- (void)addContentBlockHeader:(NSString*)title andExcerpt:(NSString*)excerpt andImagePublicUrl:(NSString*)imagePublicUrl {
  
  XMMResponseContentBlockType0 *contentBlock0 = [[XMMResponseContentBlockType0 alloc] init];
  contentBlock0.contentBlockType = 0;
  contentBlock0.title = title;
  contentBlock0.text = excerpt;
  [self displayContentBlock0:contentBlock0];
  
  if (imagePublicUrl != nil && ![imagePublicUrl isEqualToString:@""]) {
    XMMResponseContentBlockType3 *contentBlock3 = [[XMMResponseContentBlockType3 alloc] init];
    contentBlock3.fileId = imagePublicUrl;
    [self displayContentBlock3:contentBlock3];
  }
}

- (void)generateTableViewCellsWithContentBlocks:(NSArray*)contentBlocks {
  for (XMMResponseContentBlock *contentBlock in contentBlocks) {
    
    switch (contentBlock.contentBlockType) {
      case 0: {
        XMMResponseContentBlockType0 *contentBlock0 = (XMMResponseContentBlockType0*)contentBlock;
        [self displayContentBlock0:contentBlock0];
        break;
      }
      case 1: {
        XMMResponseContentBlockType1 *contentBlock1 = (XMMResponseContentBlockType1*)contentBlock;
        [self displayContentBlock1:contentBlock1];
        break;
      }
      case 2: {
        XMMResponseContentBlockType2 *contentBlock2 = (XMMResponseContentBlockType2*)contentBlock;
        [self displayContentBlock2:contentBlock2];
        break;
      }
      case 3: {
        XMMResponseContentBlockType3 *contentBlock3 = (XMMResponseContentBlockType3*)contentBlock;
        [self displayContentBlock3:contentBlock3];
        break;
      }
      case 4: {
        XMMResponseContentBlockType4 *contentBlock4 = (XMMResponseContentBlockType4*)contentBlock;
        [self displayContentBlock4:contentBlock4];
        break;
      }
      case 5: {
        XMMResponseContentBlockType5 *contentBlock5 = (XMMResponseContentBlockType5*)contentBlock;
        [self displayContentBlock5:contentBlock5];
        break;
      }
      case 6: {
        XMMResponseContentBlockType6 *contentBlock6 = (XMMResponseContentBlockType6*)contentBlock;
        [self displayContentBlock6:contentBlock6];
        break;
      }
      case 7: {
        XMMResponseContentBlockType7 *contentBlock7 = (XMMResponseContentBlockType7*)contentBlock;
        [self displayContentBlock7:contentBlock7];
        break;
      }
      case 8: {
        XMMResponseContentBlockType8 *contentBlock8 = (XMMResponseContentBlockType8*)contentBlock;
        [self displayContentBlock8:contentBlock8];
        break;
      }
      case 9: {
        XMMResponseContentBlockType9 *contentBlock9 = (XMMResponseContentBlockType9*)contentBlock;
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
- (void)displayContentBlock0:(XMMResponseContentBlockType0 *)contentBlock {
  TextBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //save data for later use
  cell.titleText = contentBlock.title;
  cell.contentText = contentBlock.text;
  cell.contentBlockType = contentBlock.contentBlockType;
  
  //set title
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""]) {
    cell.titleLabel.text = contentBlock.title;
    [cell.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize+5]];
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
- (void)displayContentBlock1:(XMMResponseContentBlockType1 *)contentBlock {
  AudioBlockTableViewCell *cell;
  
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AudioBlockTableViewCell" owner:self options:nil];
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
- (void)displayContentBlock2:(XMMResponseContentBlockType2 *)contentBlock {
  YoutubeBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YoutubeBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title and youtubeUrl
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  //get the videoId from the string
  NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
  NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
  NSArray *array = [regExp matchesInString:contentBlock.youtubeUrl options:0 range:NSMakeRange(0,contentBlock.youtubeUrl.length)];
  if (array.count > 0) {
    NSTextCheckingResult *result = array.firstObject;
    NSString* youtubeVideoId = [contentBlock.youtubeUrl substringWithRange:result.range];
    //load video inside playerView
    [cell.playerView loadWithVideoId:youtubeVideoId];
  }
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Image Block
- (void)displayContentBlock3:(XMMResponseContentBlockType3 *)contentBlock {
  ImageBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImageBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
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
  
  [self.itemsToDisplay addObject:cell];
}


#pragma mark Link Block
- (void)displayContentBlock4:(XMMResponseContentBlockType4 *)contentBlock {
  LinkBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LinkBlockTableViewCell" owner:self options:nil];
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
- (void)displayContentBlock5:(XMMResponseContentBlockType5 *)contentBlock {
  EbookBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EbookBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, artist and downloadUrl
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  
  cell.artistLabel.text = contentBlock.artist;
  cell.downloadUrl = contentBlock.fileId;
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Content Block
- (void)displayContentBlock6:(XMMResponseContentBlockType6 *)contentBlock {
  ContentBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContentBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set content
  cell.contentId = contentBlock.contentId;
  
  //init contentBlock
  [cell initContentBlockWithLanguage:self.language];
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark Soundcloud Block
- (void)displayContentBlock7:(XMMResponseContentBlockType7 *)contentBlock {
  SoundcloudBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SoundcloudBlockTableViewCell" owner:self options:nil];
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
- (void)displayContentBlock8:(XMMResponseContentBlockType8 *)contentBlock {
  DownloadBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DownloadBlockTableViewCell" owner:self options:nil];
  cell = nib[0];
  
  //set title, text, fileId and downloadType
  cell.titleLabel.text = contentBlock.title;
  cell.contentTextLabel.text = contentBlock.text;
  cell.fileId = contentBlock.fileId;
  cell.downloadType = contentBlock.downloadType;
  
  [self.itemsToDisplay addObject:cell];
}

#pragma mark SpotMap Block
- (void)displayContentBlock9:(XMMResponseContentBlockType9 *)contentBlock {
  SpotMapBlockTableViewCell *cell;
  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SpotMapBlockTableViewCell" owner:self options:nil];
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
  for (XMMResponseContentBlock *contentItem in self.itemsToDisplay) {
    if ([contentItem isKindOfClass:[TextBlockTableViewCell class]]) {
      TextBlockTableViewCell* textBlock = (TextBlockTableViewCell*)contentItem;
      textBlock.contentTextView.attributedText = [self attributedStringFromHTML:textBlock.contentText];
      [textBlock.titleLabel setFont:[UIFont boldSystemFontOfSize:self.fontSize+7]];
    }
  }
  
  [self reloadTableView];
}

@end
