//
//  feedItemData.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMMEnduserApi.h"

@interface FeedItemData : NSObject

@property UIImage *image;
@property XMMResponseContent *content;

@end
