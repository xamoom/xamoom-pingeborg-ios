//
//  ContentBlockTableViewCell.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "ArtistDetailViewController.h"

@interface ContentBlockTableViewCell : UITableViewCell <XMMEnderuserApiDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentExcerptLabel;

- (IBAction)clickOnContentBlock:(id)sender;

@property NSString *contentId;
@property XMMResponseGetById *result;

- (void)getContent;

@end
