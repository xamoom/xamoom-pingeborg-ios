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

int y;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.backBarButtonItem.title = @"Back";
    
    //set view height to 1000
    CGRect frame = self.view.frame;
    frame.size.height = 1000;
    [self.view setFrame:frame];
    //set scrollViewHeight to 2000
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, 2000.0);
    y = 45;
    
    //self.testLabel.text = self.result.content.title;
    
    //UIImage* myImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.result.content.imagePublicUrl]]];
    //[self.testImage setImage:myImage];
    
    [self addContentBlocks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addContentBlocks {
    
    NSArray *contentBlocks = self.result.content.contentBlocks;
    
    for (XMMResponseContentBlock* block in contentBlocks) {
        switch ([block.contentBlockType integerValue]) {
            case 0:
                [self showContentBlockText:(XMMResponseContentBlockType0*)block];
                break;
                
            default:
                break;
        }
    }
}

- (void)showContentBlockText:(XMMResponseContentBlockType0*)block {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,y,self.view.frame.size.width,45)];
    label.text= [block.text stringByDecodingHTMLEntities];
    [self.scrollView addSubview:label];
    y += 45;
}


- (void)viewDidAppear:(BOOL)animated {
    self.parentViewController.navigationItem.title = self.result.systemName;
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
