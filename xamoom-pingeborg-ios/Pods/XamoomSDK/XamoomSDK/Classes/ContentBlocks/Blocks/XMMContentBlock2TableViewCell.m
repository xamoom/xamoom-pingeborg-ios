//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock2TableViewCell.h"

@interface XMMContentBlock2TableViewCell()

@property (strong, nonatomic) NSString* videoUrl;
@property (nonatomic) float screenWidth;
@property (nonatomic) UIImage *playImage;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *openInYoutubeView;

@end

@implementation XMMContentBlock2TableViewCell

- (void)awakeFromNib {
  // Initialization code
  self.videoPlayer = nil;
  self.fileManager = [[XMMOfflineFileManager alloc] init];
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.playImage = [UIImage imageNamed:@"videoPlay"
                              inBundle:imageBundle compatibleWithTraitCollection:nil];
  self.webView.scrollView.scrollEnabled = false;
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.videoPlayer = nil;
  self.titleLabel.text = nil;
  self.webView.hidden = YES;
  self.thumbnailImageView.hidden = NO;
  self.playIconImageView.hidden = NO;
  self.openInYoutubeView.hidden = YES;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.videoUrl = block.videoUrl;
  if (style.foregroundFontColor) {
    self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  }
  self.titleLabel.text = block.title;
  self.playIconImageView.image = self.playImage;
  
  if (offline) {
    [self determineVideoFromURLString:[self.fileManager urlForSavedData:self.videoUrl].absoluteString];
  } else {
    [self determineVideoFromURLString:self.videoUrl];
  }
}

- (void)determineVideoFromURLString:(NSString*)videoURLString {
  NSString *youtubeVideoID = [self youtubeVideoIdFromURL:videoURLString];
  
  if (youtubeVideoID != nil) {
    self.webView.hidden = NO;
    self.thumbnailImageView.hidden = YES;
    self.playIconImageView.hidden = YES;
    self.openInYoutubeView.hidden = NO;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openYoutubeUrl)];
    [self.openInYoutubeView addGestureRecognizer:gestureRecognizer];

    NSInteger timeStamp = [self youtubeTimestampFromUrl:videoURLString];
    [self showYoutubeWithId:youtubeVideoID timeStamp:timeStamp];
  } else if ([videoURLString containsString:@"vimeo"]) {
    self.webView.hidden = NO;
    self.thumbnailImageView.hidden = YES;
    self.playIconImageView.hidden = YES;
    [self showVimeoFromUrl:videoURLString];
  } else {
    self.thumbnailImageView.hidden = NO;
    self.playIconImageView.hidden = NO;
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

- (NSInteger)youtubeTimestampFromUrl:(NSString *)url {
  NSError *error = nil;
  NSString *regexString = @"\(&t=|\\\?t=)\(\?:\(\\d+h)\?\(\\d+m)\?\(\\d+s)\?\(\\d+)\?)";
  NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                          options:NSRegularExpressionCaseInsensitive
                                                                            error:&error];
  NSArray *array = [regExp matchesInString:url options:0 range:NSMakeRange(0,url.length)];
  
  NSInteger startSeconds = 0;

  if(array.count >= 1) {
    NSTextCheckingResult *result = array.firstObject;
    
    NSRange range = [result rangeAtIndex:0];
    
    range = [result rangeAtIndex:1];
    if (range.location != NSNotFound) {
      NSLog(@"group1: %@", [url substringWithRange:range]);
    }
    
    // hours
    range = [result rangeAtIndex:2];
    if (range.location != NSNotFound) {
      int hours = [[url substringWithRange:range] intValue];
      startSeconds += hours * 60 * 60; // to seconds
    }

    // minutes
    range = [result rangeAtIndex:3];
    if (range.location != NSNotFound) {
      int minutes = [[url substringWithRange:range] intValue];
      startSeconds += minutes * 60; // to seconds
    }
    
    // seconds
    range = [result rangeAtIndex:4];
    if (range.location != NSNotFound) {
      int seconds = [[url substringWithRange:range] intValue];
      startSeconds += seconds;
    }

    // time already in seconds
    range = [result rangeAtIndex:5];
    if (range.location != NSNotFound) {
      startSeconds = [[url substringWithRange:range] integerValue];
    }
  }
  
  return startSeconds;
}

- (void)openYoutubeUrl {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.videoUrl]];
}

- (void)showYoutubeWithId:(NSString *)videoId timeStamp:(NSInteger)seconds {
  NSString *htmlString = [NSString stringWithFormat:@"<style>html, body {margin: 0;padding:0;}</style><iframe width=\"100%%\" height=\"100%%\" src=\"https://www.youtube.com/embed/%@?start=%ld\" frameborder=\"0\" allowfullscreen></iframe>", videoId, (long)seconds];
  [self.webView loadHTMLString:htmlString baseURL:nil];
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

@end
