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

+ (Globals*)sharedObject;

+ (NSString*)getSystemIdFromInteger:(NSInteger)systemId;

+ (void)addDiscoveredArtist:(NSString*)contentId;

+ (NSString*)savedArtits;

+ (BOOL)isFirstStart;

@end
