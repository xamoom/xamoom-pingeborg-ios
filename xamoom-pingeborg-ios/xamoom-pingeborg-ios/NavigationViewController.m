//
//  NavigationViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 27/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation NavigationViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"pingeborg Klagenfurt"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                            [self changePingeborgSystemWithId:0];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"pingeborg Salzburg"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                            [self changePingeborgSystemWithId:1];
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"pingeborg Villach"
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self changePingeborgSystemWithId:2];
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"pingeborg Vorarlberg"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self changePingeborgSystemWithId:3];
                                                         }];
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    //self.menu.delegate = self;
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

- (void)changePingeborgSystemWithId:(NSInteger)selectedId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedId
                      forKey:@"location"];
    [userDefaults setBool:YES
                   forKey:@"isPingeborgSystemChanged"];
    [userDefaults synchronize];
    
    [delegate performSelector:@selector(didChangeSystem)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
