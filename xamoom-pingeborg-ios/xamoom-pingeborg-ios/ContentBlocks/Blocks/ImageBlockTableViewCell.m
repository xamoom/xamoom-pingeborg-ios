//
//  ImageBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ImageBlockTableViewCell.h"

@implementation ImageBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToPhotoLibary:)];
  longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)saveImageToPhotoLibary:(UILongPressGestureRecognizer*)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bild speichern"
                                                    message:@"Willst du das Bild in dein Fotoalbum speichern?"
                                                   delegate:self
                                          cancelButtonTitle:@"Ja"
                                          otherButtonTitles:@"Abbrechen", nil];
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex == 0) {
    UIImageWriteToSavedPhotosAlbum(self.image.image, nil, nil, nil);
  }
}



@end
