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
#import "XMMMovingBarsView.h"
#import "XMMProgressBar.h"
#import "XMMAudioManager.h"

/**
 * XMMContentBlock1TableViewCell is used to display the XMMMusicPlayer for audio contentBlocks form the xamoom system.
 */
@interface XMMContentBlock1TableViewCell : UITableViewCell <UIAppearanceContainer>

@property (weak, nonatomic) IBOutlet UIView * _Nullable audioPlayerView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable artistLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable audioControlButton;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable forwardButton;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable backwardButton;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable backwardLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable forwardLabel;
@property (weak, nonatomic) IBOutlet XMMMovingBarsView * _Nullable movingBarView;
@property (weak, nonatomic) IBOutlet XMMProgressBar * _Nullable progressBar;
@property (nonatomic, getter=isPlaying) BOOL playing;
@property (strong, nonatomic) XMMOfflineFileManager * _Nullable fileManager;
@property (strong, nonnull) UIColor *audioPlayerBackgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonnull) UIColor *audioPlayerProgressBarColor UI_APPEARANCE_SELECTOR;
@property (strong, nonnull) UIColor *audioPlayerProgressBarBackgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonnull) UIColor *audioPlayerTintColor UI_APPEARANCE_SELECTOR;

- (IBAction)playButtonTouched:(id _Nonnull )sender;

- (void)setAudioPlayerBackgroundColor:(UIColor * _Nonnull)audioPlayerBackgroundColor;
- (UIColor * _Nullable)audioPlayerBackgroundColor;
- (void)setAudioPlayerProgressBarColor:(UIColor * _Nonnull)audioPlayerProgressBarColor;
- (UIColor * _Nullable)audioPlayerProgressBarColor;
- (void)setAudioPlayerProgressBarBackgroundColor:(UIColor * _Nonnull)audioPlayerProgressBarBackgroundColor;
- (UIColor * _Nullable)audioPlayerProgressBarBackgroundColor;
- (void)setAudioPlayerTintColor:(UIColor * _Nonnull)audioPlayerTextColors;
- (UIColor * _Nullable)audioPlayerTintColor;

@end

@interface XMMContentBlock1TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *_Nonnull)block tableView:(UITableView *_Nonnull)tableView indexPath:(NSIndexPath *_Nonnull)indexPath style:(XMMStyle *_Nullable)style offline:(BOOL)offline;

@end
