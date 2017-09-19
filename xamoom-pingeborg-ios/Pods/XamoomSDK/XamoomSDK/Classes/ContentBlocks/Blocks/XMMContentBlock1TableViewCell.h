//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "XMMMusicPlayer.h"
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"
#import "MovingBarsView.h"

/**
 * XMMContentBlock1TableViewCell is used to display the XMMMusicPlayer for audio contentBlocks form the xamoom system.
 */
@interface XMMContentBlock1TableViewCell : UITableViewCell <XMMMusicPlayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioControlButton;
@property (weak, nonatomic) IBOutlet MovingBarsView *movingBarView;
@property (weak, nonatomic) IBOutlet XMMMusicPlayer *audioPlayerControl;
@property (nonatomic, getter=isPlaying) BOOL playing;
@property (strong, nonatomic) XMMOfflineFileManager *fileManager;

- (IBAction)playButtonTouched:(id)sender;

@end

@interface XMMContentBlock1TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
