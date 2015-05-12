//
//  SoundcloudBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundcloudBlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
