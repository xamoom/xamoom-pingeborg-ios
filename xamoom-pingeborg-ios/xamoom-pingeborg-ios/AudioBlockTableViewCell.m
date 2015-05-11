//
//  AudioBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 08/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "AudioBlockTableViewCell.h"


@implementation AudioBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)dealloc {
  [self.audioPlayerControl.audioPlayer pause];
}

@end
