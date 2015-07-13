//
//  constants.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 17/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Globals : NSObject

@property (nonatomic) NSString *aboutPageId;

@property (nonatomic) UIColor *pingeborgYellow;
@property (nonatomic) UIColor *pingeborgLinkColor;

@property BOOL isDev;

+ (Globals*)sharedObject;

+ (void)setSystemFromInteger:(NSInteger)systemId;

+ (void)addDiscoveredArtist:(NSString*)contentId;

+ (NSString*)savedArtits;

+ (NSArray*)savedArtitsAsArray;

+ (BOOL)isFirstStart;

+ (BOOL)isFirstTimeGeofencing;

- (void)developmentMode;

@end
