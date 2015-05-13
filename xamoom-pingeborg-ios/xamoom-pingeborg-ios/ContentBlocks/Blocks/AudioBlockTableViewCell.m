//
//  AudioBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 08/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "AudioBlockTableViewCell.h"

@interface AudioBlockTableViewCell ()

@property BOOL isPlaying;

@end

@implementation AudioBlockTableViewCell

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pauseAllXMMMusicPlayer)
                                               name:@"pauseAllSounds"
                                             object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (IBAction)playButtonTouched:(id)sender {
  if (!self.isPlaying) {
    [self.audioPlayerControl play];
    self.isPlaying = YES;
    [self.audioControlButton setImage:[UIImage imageNamed:@"pausebutton"] forState:UIControlStateNormal];
  } else {
    [self.audioPlayerControl pause];
    self.isPlaying = NO;
    [self.audioControlButton setImage:[UIImage imageNamed:@"playbutton"] forState:UIControlStateNormal];
  }
}

-(void)didUpdateRemainingSongTime:(NSString *)remainingSongTime {
  self.remainingTimeLabel.text = remainingSongTime;
}

- (void)pauseAllXMMMusicPlayer {
  [self.audioPlayerControl pause];
}

@end
