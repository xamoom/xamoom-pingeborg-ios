//
//  Analytics.h
//  pingeb.org
//
//  Created by Raphael Seher on 16.07.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/Analytics.h>

@interface Analytics : NSObject

+ (Analytics*)sharedObject;

- (void)setScreenName:(NSString*)name;

- (void)sendEventWithCategorie:(NSString*)categeorie andAction:(NSString*)action andLabel:(NSString*)label andValue:(NSNumber*)value;

@end
