//
//  ScanResultViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testLabel.text = self.result.content.title;
    
    UIImage* myImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.result.content.imagePublicUrl]]];
    
    [self.testImage setImage:myImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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