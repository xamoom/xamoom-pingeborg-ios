//
//  NavigationViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 27/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "REMenu.h"

#pragma mark - NavigationViewController Interface

@interface NavigationViewController : UINavigationController

@property (strong, readonly, nonatomic) REMenu *menu;

- (void)toggleMenu;

@end
