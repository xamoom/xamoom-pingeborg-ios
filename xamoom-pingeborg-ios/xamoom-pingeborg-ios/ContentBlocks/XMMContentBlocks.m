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

int const kHorizontalSpaceToSubview = 32;

#pragma mark - XMMContentBlocks Interface

@interface XMMContentBlocks ()

@property int fontSize;

@end

#pragma mark - XMMContentBlocks Implementation

@implementation XMMContentBlocks

- (instancetype)init {
  self = [super init];
  
  if(self) {
    self.itemsToDisplay = [[NSMutableArray alloc] init];
    self.fontSize = NormalFontSize;
    self.linkColor = [UIColor blueColor];
    self.language = @"en";
  }
  
  //notification to reload delegates tableview from special contentBlockCells
  NSString *notificationName = @"reloadTableViewForContentBlocks";
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reloadTableView)
                                               name:notificationName
                                             object:nil];
  return self;
}

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
  [self generateTableViewCellsWithContentBlocks:idResult.content.contentBlocks];
}

- (void)displayContentBlocksByLocationIdentifierResult:(XMMResponseGetByLocationIdentifier *)locationIdentifierResult {
  if (locationIdentifierResult == nil) {
    return;
  }
  [self generateTableViewCellsWithContentBlocks:locationIdentifierResult.content.contentBlocks];
}

- (void)generateTableViewCellsWithContentBlocks:(NSArray*)contentBlocks {
  NSInteger contentBlockType;
  
  for (XMMResponseContentBlock *contentBlock in contentBlocks) {
    contentBlockType = [contentBlock.contentBlockType integerValue];
    
    switch (contentBlockType) {
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
  if(contentBlock.title != nil && ![contentBlock.title isEqualToString:@""])
    cell.titleLabel.text = contentBlock.title;
  else
    
  
  //bigger font if it is a contenttype "title"
  if ([contentBlock.contentBlockType isEqualToString:@"title"]) {
    [cell.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize+15]];
  }
  
  //set content
  if (![cell.contentText isEqualToString:@""]) {
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
  
  //download image
  [XMMImageUtility imageWithUrl:contentBlock.fileId completionBlock:^(BOOL succeeded, UIImage *image, SVGKImage *svgImage) {
    float imageRatio;
    
    if (image != nil) {
      imageRatio = image.size.width/image.size.height;
      
      //smaller images will be displayed normal size and centered
      if (image.size.width < cell.image.frame.size.width) {
        [cell.image setContentMode:UIViewContentModeCenter];
        [cell.imageHeightConstraint setConstant:image.size.height];
      }
      else {
        //bigger images will be resized und displayed full-width
        [cell.imageHeightConstraint setConstant:(self.screenWidth / imageRatio)];
      }
      
      [cell.image setImage:image];
    } else if (svgImage != nil) {
      imageRatio = svgImage.size.width/svgImage.size.height;
      [cell.imageHeightConstraint setConstant:(self.screenWidth / imageRatio)];
      
      SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
      [svgImageView setFrame:CGRectMake(0, 0, self.screenWidth, (self.screenWidth / imageRatio))];
      [cell.image addSubview:svgImageView];
    }
    
    [cell.imageLoadingIndicator stopAnimating];
    [self reloadTableView];
  }];
  
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
  
  NSString *style = [NSString stringWithFormat:@"<style>body{font-family: \"HelveticaNeue-Light\", \"Helvetica Neue Light\", \"Helvetica Neue\", Helvetica, Arial, \"Lucida Grande\", sans-serif; font-size:%dpt; margin:0 !important;} p:last-child, p:last-of-type{margin:1px !important;} </style>", self.fontSize];
  
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
      
      if ([contentItem.contentBlockType isEqualToString:@"title"]) {
        [textBlock.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize+15]];
      }
    }
  }
  
  [self reloadTableView];
}

- (NSString*)colorToWeb:(UIColor*)color {
  NSString *webColor = nil;
  
  // This method only works for RGB colors
  if (color && CGColorGetNumberOfComponents(color.CGColor) == 4) {
    // Get the red, green and blue components
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
    CGFloat red, green, blue;
    red = roundf(components[0] * 255.0);
    green = roundf(components[1] * 255.0);
    blue = roundf(components[2] * 255.0);
    
    // Convert with %02x (use 02 to always get two chars)
    webColor = [[NSString alloc]initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue];
  }
  
  return webColor;
}

#pragma mark - Image methods

- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                           {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else{
                             completionBlock(NO,nil);
                           }
                         }];
}

@end
