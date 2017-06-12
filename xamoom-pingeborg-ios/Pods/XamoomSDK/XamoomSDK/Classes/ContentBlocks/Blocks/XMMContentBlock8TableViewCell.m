//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import "XMMContentBlock8TableViewCell.h"

@interface XMMContentBlock8TableViewCell() <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *docController;
@property (nonatomic) int downloadType;

@end

@implementation XMMContentBlock8TableViewCell

- (void)awakeFromNib {
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
  
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.calendarImage = [[UIImage imageNamed:@"cal"
                                  inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.contactImage = [[UIImage imageNamed:@"contact"
                                 inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  
  [super awakeFromNib];
}

- (void)prepareForReuse {
  self.titleLabel.text = nil;
  self.contentTextLabel.text = nil;
  self.fileID = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.offline = offline;
  self.titleLabel.text = block.title;
  self.contentTextLabel.text = block.text;
  self.fileID = block.fileID;
  self.downloadType = block.downloadType;

  [self styleBlockForType:block.downloadType];
}

- (void)styleBlockForType:(int)type {
  switch (type) {
    case 0:
      [self.icon setImage:self.contactImage];
      self.icon.tintColor = UIColor.whiteColor;
      self.viewForBackground.backgroundColor = [UIColor colorWithHexString:@"#AA3F41"];
      break;
      
    case 1:
      [self.icon setImage:self.calendarImage];
      self.icon.tintColor = UIColor.whiteColor;
      self.viewForBackground.backgroundColor = [UIColor colorWithHexString:@"#3b5998"];
      break;
  }
}

- (void)openLink {
  if (self.offline && self.downloadType == 0) {
    NSURL *localURL = [self.fileManager urlForSavedData:self.fileID];
    
    if (localURL != nil) {
      self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
      self.docController.delegate = self;
      [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
    }
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.fileID]];
  }
}

- (XMMOfflineFileManager *)fileManager {
  if (_fileManager == nil) {
    _fileManager = [[XMMOfflineFileManager alloc] init];
  }
  return _fileManager;
}

@end
