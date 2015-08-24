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
#import "XMMMusicPlayer.h"

/**
 AudioBlockTableViewCell is used to display the XMMMusicPlayer for audio contentBlocks form the xamoom system.
 */
@interface AudioBlockTableViewCell : UITableViewCell <XMMMusicerPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioControlButton;
@property (weak, nonatomic) IBOutlet XMMMusicPlayer *audioPlayerControl;

- (IBAction)playButtonTouched:(id)sender;

@end
