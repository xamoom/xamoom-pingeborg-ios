//
//  constants.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 17/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject

@property (nonatomic) NSString *globalSystemId;
@property (nonatomic) NSString *aboutPageId;
@property BOOL isDev;

+ (Globals*)sharedObject;

+ (NSString*)systemIdFromInteger:(NSInteger)systemId;

+ (void)addDiscoveredArtist:(NSString*)contentId;

+ (NSString*)savedArtits;

+ (BOOL)isFirstStart;

- (void)developmentMode;

@end
