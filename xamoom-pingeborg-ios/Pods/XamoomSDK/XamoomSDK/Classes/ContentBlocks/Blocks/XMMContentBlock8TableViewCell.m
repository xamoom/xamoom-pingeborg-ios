//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock8TableViewCell.h"

@interface XMMContentBlock8TableViewCell() <UIDocumentInteractionControllerDelegate>

@property (strong, nonatomic) UIDocumentInteractionController *docController;
@property (nonatomic) int downloadType;
@property (nonatomic) UIColor *currentCalendarColor;
@property (nonatomic) UIColor *currentCalendarTintColor;
@property (nonatomic) UIColor *currentContactColor;
@property (nonatomic) UIColor *currentContactTintColor;

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
  
  _currentCalendarColor = [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0];
  _currentCalendarTintColor = UIColor.whiteColor;
  _currentContactColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.25 alpha:1.0];
  _currentContactTintColor = UIColor.whiteColor;
  
  [super awakeFromNib];
}

- (void)prepareForReuse {
  [super prepareForReuse];
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
      self.viewForBackground.backgroundColor = _currentContactColor;
      self.icon.tintColor = _currentContactTintColor;
      self.titleLabel.textColor = _currentContactTintColor;
      self.contentTextLabel.textColor = _currentContactTintColor;
      break;
      
    case 1:
      [self.icon setImage:self.calendarImage];
      self.viewForBackground.backgroundColor = _currentCalendarColor;
      self.icon.tintColor = _currentCalendarTintColor;
      self.titleLabel.textColor = _currentCalendarTintColor;
      self.contentTextLabel.textColor = _currentCalendarTintColor;
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

- (UIColor *)calendarColor {
  return _currentCalendarColor;
}

- (UIColor *)calendarTintColor {
  return _currentCalendarColor;
}

- (void)setContactColor:(UIColor *)contactColor {
  _currentContactColor = contactColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setContactTintColor:(UIColor *)contactTintColor {
  _currentContactTintColor = contactTintColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setCalendarColor:(UIColor *)calendarColor {
  _currentCalendarColor = calendarColor;
  [self styleBlockForType:self.downloadType];
}

- (void)setCalendarTintColor:(UIColor *)calendarTintColor {
  _currentCalendarTintColor = calendarTintColor;
  [self styleBlockForType:self.downloadType];
}
@end
