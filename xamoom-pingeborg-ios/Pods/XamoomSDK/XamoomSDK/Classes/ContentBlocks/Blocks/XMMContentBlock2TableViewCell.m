//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
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

#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCell()

@property (strong, nonatomic) NSString* videoUrl;
@property (nonatomic) float screenWidth;
@property (nonatomic) UIImage *playImage;

@end

@implementation XMMContentBlock2TableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.videoPlayer = nil;
  self.playImage = [UIImage imageNamed:@"videoPlay"];
  self.webView.scrollView.scrollEnabled = false;
}

- (void)prepareForReuse {
  self.videoPlayer = nil;
  self.titleLabel.text = nil;
  self.webView.hidden = YES;
  self.thumbnailImageView.hidden = NO;
  self.playIconImageView.hidden = NO;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style {
  self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  self.titleLabel.text = block.title;
  
  self.playIconImageView.image = self.playImage;
  [self determineVideoFromURLString:block.videoUrl];
}

- (void)determineVideoFromURLString:(NSString*)videoURLString {
  NSString *youtubeVideoID = [self youtubeVideoIdFromURL:videoURLString];
  
  if (youtubeVideoID != nil) {
    [self showYoutube];
    [self.youtubePlayerView loadWithVideoId:youtubeVideoID];
  } else if ([videoURLString containsString:@"vimeo"]) {
    [self hideYoutube];
    self.webView.hidden = NO;
    self.thumbnailImageView.hidden = YES;
    self.playIconImageView.hidden = YES;
    [self showVimeoFromUrl:videoURLString];
  } else {
    [self hideYoutube];
    [self videoPlayerWithURL:[NSURL URLWithString:videoURLString]];
    [self thumbnailFromUrl:[NSURL URLWithString:videoURLString] completion:^(UIImage *image) {
      self.thumbnailImageView.image = image;
    }];
  }
}

- (NSString*)youtubeVideoIdFromURL:(NSString*)videoUrl {
  //get the youtube videoId from the string
  NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
  NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
  NSArray *array = [regExp matchesInString:videoUrl options:0 range:NSMakeRange(0,videoUrl.length)];
  
  if(array.count == 1) {
    NSTextCheckingResult *result = array.firstObject;
    return [videoUrl substringWithRange:result.range];;
  } else {
    return nil;
  }
}

- (void)showVimeoFromUrl:(NSString *)vimeoUrl {
  NSString *regexString = @"(?<=vimeo.com/)([a-z0-9]*)";
  NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:nil];
  NSTextCheckingResult *array = [regExp firstMatchInString:vimeoUrl options:0 range:NSMakeRange(0, vimeoUrl.length)];
  NSString *videoId =[vimeoUrl substringWithRange:array.range];
  NSString *htmlString = [NSString stringWithFormat:@"<style>html,body{margin:0;padding:0;}</style><iframe src=\"https://player.vimeo.com/video/%@?color=ffffff&title=0&byline=0&portrait=0\" width=\"100%%\" height=\"100%%\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>", videoId];
  
  [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)videoPlayerWithURL:(NSURL *)videoUrl {
  self.videoPlayer = [[AVPlayer alloc] initWithURL:videoUrl];
}

- (void)thumbnailFromUrl:(NSURL *)videoUrl completion:(void (^)(UIImage* image))completion {
  dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:[AVAsset assetWithURL:videoUrl]];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    dispatch_async( dispatch_get_main_queue(), ^{
      completion(thumbnail);
    });
  });
}

- (void)openVideo {
  if (self.videoPlayer) {
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = self.videoPlayer;
    
    [self.window.rootViewController presentViewController:playerViewController animated:YES completion:^{
      [playerViewController.player play];
    }];
  }
}

- (void)hideYoutube {
  self.youtubePlayerView.hidden = YES;
  self.playIconImageView.hidden = NO;
  self.thumbnailImageView.hidden = NO;
}

- (void)showYoutube {
  self.youtubePlayerView.hidden = NO;
  self.playIconImageView.hidden = YES;
  self.thumbnailImageView.hidden = YES;
}

@end
