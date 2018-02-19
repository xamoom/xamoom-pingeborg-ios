//
//  XMMPlaybackDelegate.h
//  XamoomSDK
//
//  Created by Raphael Seher on 19.01.18.
//  Copyright © 2018 xamoom GmbH. All rights reserved.
//

@protocol XMMPlaybackDelegate <NSObject>

- (void)playFileAt:(NSString *)ID;
- (void)pauseFileAt:(NSString *)ID;
- (void)stopFileAt:(NSString *)ID;
- (void)seekForwardFileAt:(NSString *)ID time:(long)seekTime;
- (void)seekBackwardFileAt:(NSString *)ID time:(long)seekTime;

@end
