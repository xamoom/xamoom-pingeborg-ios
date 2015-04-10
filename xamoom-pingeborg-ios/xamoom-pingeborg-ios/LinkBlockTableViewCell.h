//
//  LinkBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkBlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;

@property NSString *linkUrl;
@property NSString *linkType;



- (IBAction)linkClicked:(id)sender;

@end
