//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock7TableViewCell.h"

static int kWebViewSoundcloudPadding = 8;

@interface XMMContentBlock7TableViewCell()

@end

@implementation XMMContentBlock7TableViewCell

- (void)awakeFromNib {
  self.titleLabel.text = nil;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pauseAllSounds)
                                               name:@"pauseAllSounds"
                                             object:nil];
  [super awakeFromNib];
}

- (void)pauseAllSounds {
  //reload the webView so the soundcloud don't play anymore
  [self.webView reload];
}

- (void)prepareForReuse {
  self.titleLabel.text = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  if (offline) {
    return;
  }
  
  self.titleLabel.textColor = [UIColor colorWithHexString:style.foregroundFontColor];
  
  [self.webView.scrollView setScrollEnabled:NO];
  [self.webView.scrollView setBounces:NO];
  
  if (block.title != nil) {
    self.webViewTopConstraint.constant = 8;
    self.titleLabel.text = block.title;
  } else {
    self.webViewTopConstraint.constant = 0;
  }
  
  NSString *soundcloudHTML = [NSString stringWithFormat:@"<style>body{margin:0 !important;}</style><iframe width='100%%' height='%f' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=%@&auto_play=false&hide_related=true&show_comments=false&show_comments=false&show_user=false&show_reposts=false&sharing=false&download=false&buying=false&visual=true'></iframe> <script src=\"https://w.soundcloud.com/player/api.js\" type=\"text/javascript\"></script>",self.webView.frame.size.height-kWebViewSoundcloudPadding, block.soundcloudUrl];
  
  [self.webView loadHTMLString:soundcloudHTML baseURL:nil];
}

@end
