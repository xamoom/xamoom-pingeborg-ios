//
//  ArtistDetailViewController.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 07/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMEnduserApi.h"
#import "TextBlockTableViewCell.h"
#import "AudioBlockTableViewCell.h"
#import "YoutubeBlockTableViewCell.h"

@interface ArtistDetailViewController : UITableViewController <XMMEnderuserApiDelegate>

@property NSString *contentId;

@end
