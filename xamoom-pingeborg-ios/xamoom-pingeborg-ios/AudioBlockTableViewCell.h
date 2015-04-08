//
//  AudioBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 08/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioBlockTableViewCell : UITableViewCell

@property (strong,nonatomic) MPMoviePlayerController *mp;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

@property NSString *fileId;

- (IBAction)playAudioAction:(id)sender;
- (IBAction)stopAudioAction:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;

@end
