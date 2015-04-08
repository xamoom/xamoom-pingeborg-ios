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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playAudioAction:(id)sender {
    
    NSLog(@"PLAY: %@", self.fileId);

    NSURL *mediaURL = [NSURL URLWithString:self.fileId];
    mp = [[MPMoviePlayerController alloc] initWithContentURL:mediaURL];
    
    [mp setMovieSourceType:MPMovieSourceTypeUnknown];
    
    [mp prepareToPlay];
    [mp play];
}

- (IBAction)stopAudioAction:(id)sender {
    [mp stop];
}

- (IBAction)volumeSliderChanged:(id)sender {
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.volumeSlider.value];
}

@end
