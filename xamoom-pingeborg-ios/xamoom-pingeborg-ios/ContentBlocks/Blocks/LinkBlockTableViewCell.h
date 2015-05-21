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
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *linkTextLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForBackgroundColor;

@property NSString *linkUrl;
@property NSString *linkType;

/**
 Change the style and image of the tableViewCell to look like on http://xm.gl scanned page
 */
- (void)changeStyleAccordingToLinkType;

//actions
- (IBAction)linkClicked:(id)sender;

@end
