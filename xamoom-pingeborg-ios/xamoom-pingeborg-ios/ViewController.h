//
//  ViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 05/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"

@interface ViewController : UIViewController <XMMEnderuserApiDelegate>

@property XMMEnduserApi *xmmApi;

@end

