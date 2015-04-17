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

@protocol DropDownMenuDelegate <NSObject>

@required

- (void)didChangeSystem;

@end

@interface NavigationViewController : UINavigationController

@property (nonatomic, assign) id<DropDownMenuDelegate> delegate;
@property (strong, readonly, nonatomic) REMenu *menu;

- (void)toggleMenu;

@end
