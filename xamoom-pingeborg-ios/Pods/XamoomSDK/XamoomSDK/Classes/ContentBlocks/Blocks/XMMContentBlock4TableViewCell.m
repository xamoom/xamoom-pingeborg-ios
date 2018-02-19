//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import "XMMContentBlock4TableViewCell.h"

@interface XMMContentBlock4TableViewCell()

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic) UIColor *standardGreyColor;
@property (nonatomic) UIColor *standardTintColor;
@property (nonatomic) UIColor *currentWebColor;
@property (nonatomic) UIColor *currentWebTintColor;
@property (nonatomic) UIColor *currentMailColor;
@property (nonatomic) UIColor *currentMailTintColor;
@property (nonatomic) UIColor *currentWikipediaColor;
@property (nonatomic) UIColor *currentWikipediaTintColor;
@property (nonatomic) UIColor *currentItunesColor;
@property (nonatomic) UIColor *currentItunesTintColor;
@property (nonatomic) UIColor *currentAppleColor;
@property (nonatomic) UIColor *currentAppleTintColor;
@property (nonatomic) UIColor *currentFacebookColor;
@property (nonatomic) UIColor *currentFacebookTintColor;
@property (nonatomic) UIColor *currentTwitterColor;
@property (nonatomic) UIColor *currentTwitterTintColor;
@property (nonatomic) UIColor *currentShopColor;
@property (nonatomic) UIColor *currentShopTintColor;
@property (nonatomic) UIColor *currentLinkedInColor;
@property (nonatomic) UIColor *currentLinkedInTintColor;
@property (nonatomic) UIColor *currentFlickrColor;
@property (nonatomic) UIColor *currentFlickrTintColor;
@property (nonatomic) UIColor *currentSoundcloudColor;
@property (nonatomic) UIColor *currentSoundcloudTintColor;
@property (nonatomic) UIColor *currentYoutubeColor;
@property (nonatomic) UIColor *currentYoutubeTintColor;
@property (nonatomic) UIColor *currentGoogleColor;
@property (nonatomic) UIColor *currentGoogleTintColor;
@property (nonatomic) UIColor *currentSpotifyColor;
@property (nonatomic) UIColor *currentSpotifyTintColor;
@property (nonatomic) UIColor *currentNavigationColor;
@property (nonatomic) UIColor *currentNavigationTintColor;
@property (nonatomic) UIColor *currentAndroidColor;
@property (nonatomic) UIColor *currentAndroidTintColor;
@property (nonatomic) UIColor *currentWindowsColor;
@property (nonatomic) UIColor *currentWindowsTintColor;
@property (nonatomic) UIColor *currentInstagramColor;
@property (nonatomic) UIColor *currentInstagramTintColor;
@property (nonatomic) UIColor *currentPhoneColor;
@property (nonatomic) UIColor *currentPhoneTintColor;
@property (nonatomic) UIColor *currentFallbackColor;
@property (nonatomic) UIColor *currentFallbackTintColor;

@end

@implementation XMMContentBlock4TableViewCell

- (void)awakeFromNib {
  self.linkTextLabel.text = nil;
  self.titleLabel.text = nil;
  self.linkUrl = nil;
  self.linkType = -1;

  [self setupColors];
  [self setupBundle];
  [super awakeFromNib];
}

- (void)setupColors {
  self.standardGreyColor = [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];
  self.standardTintColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];

  _currentFallbackColor = self.standardGreyColor;
  _currentFallbackTintColor = self.standardTintColor;
  _currentWebColor = self.standardGreyColor;
  _currentWebTintColor = self.standardTintColor;
  _currentMailColor = self.standardGreyColor;
  _currentMailTintColor = self.standardTintColor;
  _currentWikipediaColor = self.standardGreyColor;
  _currentWikipediaTintColor = self.standardTintColor;
  _currentItunesColor = self.standardGreyColor;
  _currentItunesTintColor = self.standardTintColor;
  _currentFacebookColor = [UIColor colorWithRed:59/255.0f green:89/255.0f blue:152/255.0f alpha:1.0f];
  _currentFacebookTintColor = UIColor.whiteColor;
  _currentTwitterColor = [UIColor colorWithRed:0.10 green:0.56 blue:0.91 alpha:1.0];
  _currentTwitterTintColor = UIColor.whiteColor;
  _currentShopColor = [UIColor colorWithRed:255/255.0f green:153/255.0f blue:0/255.0f alpha:1.0f];
  _currentShopTintColor = UIColor.blackColor;
  _currentLinkedInColor = [UIColor colorWithRed:9/255.0f green:118/255.0f blue:180/255.0f alpha:1.0f];
  _currentLinkedInTintColor = UIColor.whiteColor;
  _currentFlickrColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:132/255.0f alpha:1.0f];
  _currentFlickrTintColor = UIColor.whiteColor;
  _currentSoundcloudColor = [UIColor colorWithRed:255/255.0f green:136/255.0f blue:0/255.0f alpha:1.0f];
  _currentSoundcloudTintColor = UIColor.blackColor;
  _currentYoutubeColor = [UIColor colorWithRed:179/255.0f green:18/255.0f blue:23/255.0f alpha:1.0f];
  _currentYoutubeTintColor = UIColor.whiteColor;
  _currentGoogleColor = [UIColor colorWithRed:221/255.0f green:75/255.0f blue:57/255.0f alpha:1.0f];
  _currentGoogleTintColor = UIColor.whiteColor;
  _currentSpotifyColor = [UIColor colorWithRed:0.18 green:0.74 blue:0.35 alpha:1.0];
  _currentSpotifyTintColor = UIColor.blackColor;
  _currentNavigationColor = [UIColor colorWithRed:13/255.0f green:163/255.0f blue:96/255.0f alpha:1.0f];
  _currentNavigationTintColor = UIColor.whiteColor;
  _currentAndroidColor = [UIColor colorWithRed:0.32 green:0.42 blue:0.00 alpha:1.0];
  _currentAndroidTintColor = UIColor.whiteColor;
  _currentWindowsColor = [UIColor colorWithRed:0.17 green:0.38 blue:0.94 alpha:1.0];
  _currentWindowsTintColor = UIColor.whiteColor;
  _currentInstagramColor = [UIColor colorWithRed:0.74 green:0.16 blue:0.55 alpha:1.0];
  _currentInstagramTintColor = UIColor.whiteColor;
  _currentPhoneColor = [UIColor colorWithRed:0.24 green:0.84 blue:0.55 alpha:1.0];
  _currentPhoneTintColor = UIColor.blackColor;
  _currentAppleColor = UIColor.blackColor;
  _currentAppleTintColor = UIColor.whiteColor;
}

- (void)setupBundle {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *url = [bundle URLForResource:@"XamoomSDK" withExtension:@"bundle"];
  if (url) {
    self.bundle = [NSBundle bundleWithURL:url];
  } else {
    self.bundle = bundle;
  }
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.linkTextLabel.text = nil;
  self.titleLabel.text = nil;
  self.linkUrl = nil;
}

- (void)openLink {
  //open link in safari
  if (self.linkType == 11) {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self cleanPhoneNumber:self.linkUrl]]];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.linkUrl]];
  }
}

- (NSString *)cleanPhoneNumber:(NSString *)phoneNumber {
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  return phoneNumber;
}

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline {
  //set title, text, linkUrl and linkType
  
  if(block.title != nil) {
    self.titleLabel.text = block.title;
  }
  
  self.linkTextLabel.text = block.text;
  self.linkUrl = block.linkUrl;
  self.linkType = block.linkType;
  
  [self changeStyleAccordingToLinkType:block.linkType];
}

- (void)changeStyleAccordingToLinkType:(int)linkType {
  switch (linkType) {
    case 0: {
      [self.viewForBackgroundColor setBackgroundColor:_currentFacebookColor];
      [self.icon setImage:[UIImage imageNamed:@"facebook" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentFacebookTintColor];
      [self.linkTextLabel setTextColor:_currentFacebookTintColor];
      [self.titleLabel setTextColor:_currentFacebookTintColor];
      break;
    }
    case 1: {
      [self.viewForBackgroundColor setBackgroundColor:_currentTwitterColor];
      [self.icon setImage:[UIImage imageNamed:@"twitter" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentTwitterTintColor];
      [self.linkTextLabel setTextColor:_currentTwitterTintColor];
      [self.titleLabel setTextColor:_currentTwitterTintColor];
      break;
    }
    case 2: {
      [self.viewForBackgroundColor setBackgroundColor:_currentWebColor];
      [self.icon setImage:[UIImage imageNamed:@"web" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentWebTintColor];
      [self.linkTextLabel setTextColor:_currentWebTintColor];
      [self.titleLabel setTextColor:_currentWebTintColor];
      break;
    }
    case 3: {
      [self.viewForBackgroundColor setBackgroundColor:_currentShopColor];
      [self.icon setImage:[UIImage imageNamed:@"shop" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentShopTintColor];
      [self.linkTextLabel setTextColor:_currentShopTintColor];
      [self.titleLabel setTextColor:_currentShopTintColor];
      break;
    }
    case 4: {
      [self.viewForBackgroundColor setBackgroundColor:_currentWikipediaColor];
      [self.icon setImage:[UIImage imageNamed:@"wikipedia" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentWikipediaTintColor];
      [self.linkTextLabel setTextColor:_currentWikipediaTintColor];
      [self.titleLabel setTextColor:_currentWikipediaTintColor];
      break;
    }
    case 5: {
      [self.viewForBackgroundColor setBackgroundColor:_currentLinkedInColor];
      [self.icon setImage:[UIImage imageNamed:@"linkedin" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentLinkedInTintColor];
      [self.linkTextLabel setTextColor:_currentLinkedInTintColor];
      [self.titleLabel setTextColor:_currentLinkedInTintColor];
      break;
    }
    case 6: {
      [self.viewForBackgroundColor setBackgroundColor:_currentFlickrColor];
      [self.icon setImage:[UIImage imageNamed:@"flickr" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentFlickrTintColor];
      [self.linkTextLabel setTextColor:_currentFlickrTintColor];
      [self.titleLabel setTextColor:_currentFlickrTintColor];
      break;
    }
    case 7: {
      [self.viewForBackgroundColor setBackgroundColor:_currentSoundcloudColor];
      [self.icon setImage:[UIImage imageNamed:@"soundcloud" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentSoundcloudTintColor];
      [self.linkTextLabel setTextColor:_currentSoundcloudTintColor];
      [self.titleLabel setTextColor:_currentSoundcloudTintColor];
      break;
    }
    case 8: {
      [self.viewForBackgroundColor setBackgroundColor:_currentItunesColor];
      [self.icon setImage:[UIImage imageNamed:@"itunes" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentItunesTintColor];
      [self.linkTextLabel setTextColor:_currentItunesTintColor];
      [self.titleLabel setTextColor:_currentItunesTintColor];
      break;
    }
    case 9: {
      [self.viewForBackgroundColor setBackgroundColor:_currentYoutubeColor];
      [self.icon setImage:[UIImage imageNamed:@"youtube" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentYoutubeTintColor];
      [self.linkTextLabel setTextColor:_currentYoutubeTintColor];
      [self.titleLabel setTextColor:_currentYoutubeTintColor];
      break;
    }
    case 10: {
      [self.viewForBackgroundColor setBackgroundColor:_currentGoogleColor];
      [self.icon setImage:[UIImage imageNamed:@"google" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentGoogleTintColor];
      [self.linkTextLabel setTextColor:_currentGoogleTintColor];
      [self.titleLabel setTextColor:_currentGoogleTintColor];
      break;
    }
    case 11: {
      [self.viewForBackgroundColor setBackgroundColor:_currentPhoneColor];
      [self.icon setImage:[UIImage imageNamed:@"phone" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentPhoneTintColor];
      [self.linkTextLabel setTextColor:_currentPhoneTintColor];
      [self.titleLabel setTextColor:_currentPhoneTintColor];
      break;
    }
    case 12: {
      [self.viewForBackgroundColor setBackgroundColor:_currentMailColor];
      [self.icon setImage:[UIImage imageNamed:@"email" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentMailTintColor];
      [self.linkTextLabel setTextColor:_currentMailTintColor];
      [self.titleLabel setTextColor:_currentMailTintColor];
      break;
    }
    case 13: {
      [self.viewForBackgroundColor setBackgroundColor:_currentSpotifyColor];
      [self.icon setImage:[UIImage imageNamed:@"spotify" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentSpotifyTintColor];
      [self.linkTextLabel setTextColor:_currentSpotifyTintColor];
      [self.titleLabel setTextColor:_currentSpotifyTintColor];
      break;
    }
    case 14: {
      [self.viewForBackgroundColor setBackgroundColor:_currentNavigationColor];
      [self.icon setImage:[UIImage imageNamed:@"directional" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentNavigationTintColor];
      [self.linkTextLabel setTextColor:_currentNavigationTintColor];
      [self.titleLabel setTextColor:_currentNavigationTintColor];
      break;
    }
    case 15: {
      [self.viewForBackgroundColor setBackgroundColor:_currentAppleColor];
      [self.icon setImage:[UIImage imageNamed:@"apple" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentAppleTintColor];
      [self.linkTextLabel setTextColor:_currentAppleTintColor];
      [self.titleLabel setTextColor:_currentAppleTintColor];
      break;
    }
    case 16: {
      [self.viewForBackgroundColor setBackgroundColor:_currentAndroidColor];
      [self.icon setImage:[UIImage imageNamed:@"android" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentAndroidTintColor];
      [self.linkTextLabel setTextColor:_currentAndroidTintColor];
      [self.titleLabel setTextColor:_currentAndroidTintColor];
      break;
    }
    case 17: {
      [self.viewForBackgroundColor setBackgroundColor:_currentWindowsColor];
      [self.icon setImage:[UIImage imageNamed:@"windows" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentWindowsTintColor];
      [self.linkTextLabel setTextColor:_currentWindowsTintColor];
      [self.titleLabel setTextColor:_currentWindowsTintColor];
      break;
    }
    case 18: {
      [self.viewForBackgroundColor setBackgroundColor:_currentInstagramColor];
      [self.icon setImage:[UIImage imageNamed:@"instagram" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentInstagramTintColor];
      [self.linkTextLabel setTextColor:_currentInstagramTintColor];
      [self.titleLabel setTextColor:_currentInstagramTintColor];
      break;
    }
    default:
      NSLog(@"Linktype not recognized.");
      [self.viewForBackgroundColor setBackgroundColor:_currentFallbackColor];
      [self.icon setImage:[UIImage imageNamed:@"web" inBundle:self.bundle compatibleWithTraitCollection:nil]];
      self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.icon setTintColor:_currentFallbackTintColor];
      [self.linkTextLabel setTextColor:_currentFallbackTintColor];
      [self.titleLabel setTextColor:_currentFallbackTintColor];
      break;
  }
}

#pragma mark - Appearance Getters & Setters

-(UIColor *)webColor {
return _currentWebColor;
}

-(UIColor *)webTintColor {
  return _currentWebTintColor;
}

-(UIColor *)mailColor {
  return _currentMailColor;
}

-(UIColor *)mailTintColor {
  return _currentMailTintColor;
}

-(UIColor *)wikipediaColor {
  return _currentWikipediaColor;
}

-(UIColor *)wikipediaTintColor {
  return _currentWikipediaTintColor;
}

-(UIColor *)itunesColor {
  return _currentItunesColor;
}

-(UIColor *)itunesTintColor {
  return _currentItunesTintColor;
}

-(UIColor *)appleColor {
  return _currentAppleColor;
}

-(UIColor *)appleTintColor {
  return _currentAppleTintColor;
}

-(UIColor *)facebookColor {
  return _currentFacebookColor;
}

-(UIColor *)facebookTintColor {
  return _currentFacebookTintColor;
}

-(UIColor *)twitterColor {
  return _currentTwitterColor;
}

-(UIColor *)twitterTintColor {
  return _currentTwitterTintColor;
}

-(UIColor *)shopColor {
  return _currentShopColor;
}

-(UIColor *)shopTintColor {
  return _currentShopTintColor;
}

-(UIColor *)linkedInColor {
  return _currentLinkedInColor;
}

-(UIColor *)linkedInTintColor {
  return _currentLinkedInTintColor;
}

-(UIColor *)flickrColor {
  return _currentFlickrColor;
}

-(UIColor *)flickrTintColor {
  return _currentFlickrTintColor;
}

-(UIColor *)soundcloudColor {
  return _currentSoundcloudColor;
}

-(UIColor *)soundcloudTintColor {
  return _currentSoundcloudTintColor;
}

-(UIColor *)youtubeColor {
  return _currentYoutubeColor;
}

-(UIColor *)youtubeTintColor {
  return _currentYoutubeTintColor;
}

-(UIColor *)googleColor {
  return _currentGoogleColor;
}

-(UIColor *)googleTintColor {
  return _currentGoogleTintColor;
}

-(UIColor *)spotifyColor {
  return _currentSpotifyColor;
}

-(UIColor *)spotifyTintColor {
  return _currentSpotifyTintColor;
}

-(UIColor *)navigationColor {
  return _currentNavigationColor;
}

-(UIColor *)navigationTintColor {
  return _currentNavigationTintColor;
}

-(UIColor *)androidColor {
  return _currentAndroidColor;
}

-(UIColor *)androidTintColor {
  return _currentAndroidTintColor;
}

-(UIColor *)windowsColor {
  return _currentWindowsColor;
}

-(UIColor *)windowsTintColor {
  return _currentWindowsTintColor;
}

-(UIColor *)instagramColor {
  return _currentInstagramColor;
}

-(UIColor *)instagramTintColor {
  return _currentInstagramTintColor;
}

-(UIColor *)phoneColor {
  return _currentPhoneColor;
}

-(UIColor *)phoneTintColor {
  return _currentPhoneTintColor;
}

- (UIColor *)fallbackColor {
  return _currentFallbackColor;
}

- (UIColor *)fallbackTintColor {
  return _currentFallbackTintColor;
}

-(void)setWebColor:(UIColor *)webColor {
  _currentWebColor = webColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setWebTintColor:(UIColor *)webTintColor {
  _currentWebTintColor = webTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setMailColor:(UIColor *)mailColor {
  _currentMailColor = mailColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setMailTintColor:(UIColor *)mailTintColor {
  _currentMailTintColor = mailTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setWikipediaColor:(UIColor *)wikipediaColor {
  _currentWikipediaColor = wikipediaColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setWikipediaTintColor:(UIColor *)wikipediaTintColor {
  _currentWikipediaTintColor = wikipediaTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setItunesColor:(UIColor *)itunesColor {
  _currentItunesColor = itunesColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setItunesTintColor:(UIColor *)itunesTintColor {
  _currentItunesTintColor = itunesTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setAppleColor:(UIColor *)appleColor {
  _currentAppleColor = appleColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setAppleTintColor:(UIColor *)appleTintColor {
  _currentAppleTintColor = appleTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setFacebookColor:(UIColor *)facebookColor {
  _currentFacebookColor = facebookColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setFacebookTintColor:(UIColor *)facebookTintColor {
  _currentFacebookTintColor = facebookTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setTwitterColor:(UIColor *)twitterColor {
  _currentTwitterColor = twitterColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setTwitterTintColor:(UIColor *)twitterTintColor {
  _currentTwitterTintColor = twitterTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setShopColor:(UIColor *)shopColor {
  _currentShopColor = shopColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setShopTintColor:(UIColor *)shopTintColor {
  _currentShopTintColor = shopTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setLinkedInColor:(UIColor *)linkedInColor {
  _currentLinkedInColor = linkedInColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setLinkedInTintColor:(UIColor *)linkedInTintColor {
  _currentLinkedInTintColor = linkedInTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setFlickrColor:(UIColor *)flickrColor {
  _currentFlickrColor = flickrColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setFlickrTintColor:(UIColor *)flickrTintColor {
  _currentFlickrTintColor = flickrTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setSoundcloudColor:(UIColor *)soundcloudColor {
  _currentSoundcloudColor = soundcloudColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setSoundcloudTintColor:(UIColor *)soundcloudTintColor {
  _currentSoundcloudTintColor = soundcloudTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setYoutubeColor:(UIColor *)youtubeColor {
  _currentYoutubeColor = youtubeColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setYoutubeTintColor:(UIColor *)youtubeTintColor {
  _currentYoutubeTintColor = youtubeTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setGoogleColor:(UIColor *)googleColor {
  _currentGoogleColor = googleColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setGoogleTintColor:(UIColor *)googleTintColor {
  _currentGoogleTintColor = googleTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setSpotifyColor:(UIColor *)spotifyColor {
  _currentSpotifyColor = spotifyColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setSpotifyTintColor:(UIColor *)spotifyTintColor {
  _currentSpotifyTintColor = spotifyTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setNavigationColor:(UIColor *)navigationColor {
  _currentNavigationColor = navigationColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setNavigationTintColor:(UIColor *)navigationTintColor {
  _currentNavigationTintColor = navigationTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setAndroidColor:(UIColor *)androidColor {
  _currentAndroidColor = androidColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setAndroidTintColor:(UIColor *)androidTintColor {
  _currentAndroidTintColor = androidTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setWindowsColor:(UIColor *)windowsColor {
  _currentWindowsColor = windowsColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setWindowsTintColor:(UIColor *)windowsTintColor {
  _currentWindowsTintColor = windowsTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setInstagramColor:(UIColor *)instagramColor {
  _currentInstagramColor = instagramColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setInstagramTintColor:(UIColor *)instagramTintColor {
  _currentInstagramTintColor = instagramTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setPhoneColor:(UIColor *)phoneColor {
  _currentPhoneColor = phoneColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setPhoneTintColor:(UIColor *)phoneTintColor {
  _currentPhoneTintColor = phoneTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

-(void)setFallbackColor:(UIColor *)fallbackColor {
  _currentFallbackColor = fallbackColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

- (void)setFallbackTintColor:(UIColor *)fallbackTintColor {
  _currentFallbackTintColor = fallbackTintColor;
  [self changeStyleAccordingToLinkType:self.linkType];
}

@end
