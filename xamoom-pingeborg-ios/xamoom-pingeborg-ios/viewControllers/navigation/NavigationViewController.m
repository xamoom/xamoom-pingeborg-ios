//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation NavigationViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  //setting up REMenu "navbarDropdown"
  REMenuItem *kaernten = [[REMenuItem alloc] initWithTitle:@"pingeborg Kärnten"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                        [self changePingeborgSystemWithId:0];
                                                      }];
  
  REMenuItem *salzburg = [[REMenuItem alloc] initWithTitle:@"pingeborg Salzburg"
                                                     image:nil
                                          highlightedImage:nil
                                                    action:^(REMenuItem *item) {
                                                      [self changePingeborgSystemWithId:1];
                                                    }];
  
  
  REMenuItem *vorarlberg = [[REMenuItem alloc] initWithTitle:@"pingeborg Vorarlberg"
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                        [self changePingeborgSystemWithId:2];
                                                      }];
  //set tags
  kaernten.tag = 0;
  salzburg.tag = 1;
  vorarlberg.tag = 2;
  
  self.menu = [[REMenu alloc] initWithItems:@[kaernten, salzburg, vorarlberg]];
  self.menu.textColor = [UIColor whiteColor];
  
  self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
  self.menu.imageOffset = CGSizeMake(5, -1);
  self.menu.waitUntilAnimationIsComplete = NO;
  self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
    badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
  };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - navbarDropdown toggle

- (void)toggleMenu {
  if (self.menu.isOpen)
    return [self.menu close];
  
  [self.menu showFromNavigationController:self];
}

- (void)changePingeborgSystemWithId:(NSInteger)selectedId {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setInteger:selectedId
                    forKey:@"pingeborgSystem"];
  [userDefaults synchronize];
  
  //[Globals sharedObject].globalSystemId = [Globals systemIdFromInteger:selectedId];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PingeborgSystemChanged" object:self];
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
