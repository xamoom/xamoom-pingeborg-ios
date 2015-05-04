//
//  AudioBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 08/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "AudioBlockTableViewCell.h"


@implementation AudioBlockTableViewCell

@synthesize mp;

bool isPlaying = NO;

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (IBAction)audioButton:(id)sender {
  NSLog(@"BUTTON");
  if (!isPlaying) {
    [self.audioButton setTitle:@"Stop" forState:UIControlStateNormal];
    isPlaying = TRUE;
    
    NSURL *mediaURL = [NSURL URLWithString:self.fileId];
    mp = [[MPMoviePlayerController alloc] initWithContentURL:mediaURL];
    
    [mp setMovieSourceType:MPMovieSourceTypeUnknown];
    
    [mp prepareToPlay];
    [mp play];
  }
  else {
    [self.audioButton setTitle:@"Play" forState:UIControlStateNormal];
    isPlaying = NO;
    [mp stop];
  }
}

@end
