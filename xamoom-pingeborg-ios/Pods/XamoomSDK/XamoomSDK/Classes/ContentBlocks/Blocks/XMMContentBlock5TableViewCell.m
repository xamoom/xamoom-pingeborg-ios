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

#import "XMMContentBlock5TableViewCell.h"

@interface XMMContentBlock5TableViewCell()

@property (strong, nonatomic) UIDocumentInteractionController *docController;

@end

@implementation XMMContentBlock5TableViewCell

- (void)awakeFromNib {
  // Initialization code
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  NSBundle *imageBundle = nil;
  if (url) {
    imageBundle = [NSBundle bundleWithURL:url];
  } else {
    imageBundle = bundle;
  }
  
  self.ebookImageView.image = [[UIImage imageNamed:@"ebook"
                                          inBundle:imageBundle compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.ebookImageView.tintColor = [UIColor whiteColor];
  
  self.titleLabel.text = nil;
  self.artistLabel.text = nil;
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openInBrowser:)];
  [self addGestureRecognizer:tapGestureRecognizer];
  [super awakeFromNib];
}

- (void)prepareForReuse {
  self.titleLabel.text = nil;
  self.artistLabel.text = nil;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  self.offline = offline;
  
  //set title, artist and downloadUrl
  if(block.title != nil) {
    self.titleLabel.text = block.title;
  }
  
  self.artistLabel.text = block.artists;
  self.downloadUrl = block.fileID;
}

- (void)openInBrowser:(id)sender {
  //open url in safari
  if (self.offline) {
    NSURL *localURL = [self.fileManager urlForSavedData:self.downloadUrl];
    if (localURL != nil) {
      self.docController = [UIDocumentInteractionController interactionControllerWithURL:localURL];
      [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.contentView animated:YES];
    }
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
  }
}

- (XMMOfflineFileManager *)fileManager {
  if (_fileManager == nil) {
    _fileManager = [[XMMOfflineFileManager alloc] init];
  }
  return _fileManager;
}

@end
