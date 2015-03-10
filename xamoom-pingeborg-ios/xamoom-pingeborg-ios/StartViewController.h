//
//  StartViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeedItemView.h"
#import "XMMEnduserApi.h"

@interface StartViewController : UIViewController <RSSFeedItemViewDelegate, XMMEnderuserApiDelegate>

@end
