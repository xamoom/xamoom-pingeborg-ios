//
//  ScanResultViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"

@interface ScanResultViewController : UIViewController

@property (nonatomic, strong) XMMResponseGetByLocationIdentifier *result;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
