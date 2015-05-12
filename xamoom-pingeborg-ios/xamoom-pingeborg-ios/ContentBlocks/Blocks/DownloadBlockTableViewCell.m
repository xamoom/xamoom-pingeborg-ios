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
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setDownloadType:(NSString *)type {
  downloadType = type;
  [self.icon setImage:[self selectRightIcon]];
}

- (UIImage*)selectRightIcon {
  switch ([downloadType integerValue]) {
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
  NSLog(@"Hellyeah: %@", self.fileId);
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fileId]];
}

@end
