//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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

#import "XMMContentBlock3TableViewCell.h"

@implementation XMMContentBlock3TableViewCell

- (void)awakeFromNib {
  
  //longPressGestureRecognizer for saving images
  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToPhotoLibary:)];
  longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:longPressGestureRecognizer];
  
  //tapGesture for opening links
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink:)];
  tapGestureRecognizer.delegate = self;
  [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)saveImageToPhotoLibary:(UILongPressGestureRecognizer*)sender {
  //check if there is a SVGKImageView as Subview, because you can't save SVGImages
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bild speichern"
                                                  message:@"Willst du das Bild in dein Fotoalbum speichern?"
                                                 delegate:self
                                        cancelButtonTitle:@"Ja"
                                        otherButtonTitles:@"Abbrechen", nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 0) {
    //save image to camera roll
    UIImageWriteToSavedPhotosAlbum(self.image.image, nil, nil, nil);
  }
}

- (void)openLink:(UITapGestureRecognizer*)sender {
  if (self.linkUrl != nil && ![self.linkUrl isEqualToString:@""]) {
    NSURL *url = [NSURL URLWithString:self.linkUrl];
    [[UIApplication sharedApplication] openURL:url];
  }
}

@end
