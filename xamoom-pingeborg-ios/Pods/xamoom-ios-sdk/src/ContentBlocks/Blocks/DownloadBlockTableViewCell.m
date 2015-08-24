//
//  DownloadBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "DownloadBlockTableViewCell.h"

@implementation DownloadBlockTableViewCell

@synthesize downloadType;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setDownloadType:(int)type {
  downloadType = type;
  [self.icon setImage:[self selectRightIcon]];
}

- (UIImage*)selectRightIcon {
  //choose the right image according to the downloadType
  switch (downloadType) {
    case 0: {
      return [UIImage imageNamed:@"contact"];
      break;
    }
    case 1: {
      return [UIImage imageNamed:@"cal"];
      break;
    }
    default:
      break;
  }
  
  return nil;
}

- (IBAction)linkButtonAction:(id)sender {
  //open url in safari
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fileId]];
}

@end
