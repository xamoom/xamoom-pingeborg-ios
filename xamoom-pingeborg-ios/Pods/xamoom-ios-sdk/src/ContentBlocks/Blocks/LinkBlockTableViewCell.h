//
//  LinkBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 LinkBlockTableViewCell is used to display link contentBlocks from the xamoom system.
 */
@interface LinkBlockTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *linkTextLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForBackgroundColor;

@property NSString *linkUrl;
@property int linkType;

/**
 Change the style and image of the tableViewCell to look like on http://xm.gl scanned page
 */
- (void)changeStyleAccordingToLinkType;

//actions
- (IBAction)linkClicked:(id)sender;

@end
