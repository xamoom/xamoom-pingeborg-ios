//
//  SoundcloudBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "SoundcloudBlockTableViewCell.h"

@implementation SoundcloudBlockTableViewCell

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pauseAllSounds)
                                               name:@"pauseAllSounds"
                                             object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)pauseAllSounds {
  //reload the webView so the soundcloud don't play anymore
  [self.webView reload];
}

@end
