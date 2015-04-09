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

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;

@property (strong,nonatomic) MPMoviePlayerController *mp;
@property NSString *fileId;

- (IBAction)audioButton:(id)sender;

@end
