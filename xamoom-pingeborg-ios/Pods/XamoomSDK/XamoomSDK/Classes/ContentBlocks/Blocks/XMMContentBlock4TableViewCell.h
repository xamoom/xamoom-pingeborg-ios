//
// Copyright (c) 2017 xamoom GmbH <apps@xamoom.com>
//
// Licensed under the MIT License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at the root of this project.


#import <UIKit/UIKit.h>
#import "XMMContentBlock.h"
#import "XMMStyle.h"
#import "UIColor+HexString.h"

/**
 * LinkBlockTableViewCell is used to display link contentBlocks from the xamoom cloud.
 */
@interface XMMContentBlock4TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *linkTextLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForBackgroundColor;

@property (strong, nonatomic) NSString *linkUrl;
@property int linkType;

@property (nonatomic) UIColor *webColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *webTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *mailColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *mailTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *wikipediaColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *wikipediaTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *itunesColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *itunesTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *appleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *appleTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *facebookColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *facebookTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *twitterColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *twitterTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *shopColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *shopTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *linkedInColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *linkedInTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *flickrColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *flickrTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *soundcloudColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *soundcloudTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *youtubeColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *youtubeTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *googleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *googleTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *spotifyColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *spotifyTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *navigationColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *navigationTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *androidColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *androidTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *windowsColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *windowsTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *instagramColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *instagramTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *phoneColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *phoneTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *fallbackColor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor *fallbackTintColor UI_APPEARANCE_SELECTOR;



- (void)openLink;

-(void)setWebColor:(UIColor *)webColor;
-(void)setWebTintColor:(UIColor *)webTintColor;
-(void)setMailColor:(UIColor *)mailColor;
-(void)setMailTintColor:(UIColor *)mailTintColor;
-(void)setWikipediaColor:(UIColor *)wikipediaColor;
-(void)setWikipediaTintColor:(UIColor *)wikipediaTintColor;
-(void)setItunesColor:(UIColor *)itunesColor;
-(void)setItunesTintColor:(UIColor *)itunesTintColor;
-(void)setAppleColor:(UIColor *)appleColor;
-(void)setAppleTintColor:(UIColor *)appleTintColor;
-(void)setFacebookColor:(UIColor *)facebookColor;
-(void)setFacebookTintColor:(UIColor *)facebookTintColor;
-(void)setTwitterColor:(UIColor *)twitterColor;
-(void)setTwitterTintColor:(UIColor *)twitterTintColor;
-(void)setShopColor:(UIColor *)shopColor;
-(void)setShopTintColor:(UIColor *)shopTintColor;
-(void)setLinkedInColor:(UIColor *)linkedInColor;
-(void)setLinkedInTintColor:(UIColor *)linkedInTintColor;
-(void)setFlickrColor:(UIColor *)flickrColor;
-(void)setFlickrTintColor:(UIColor *)flickrTintColor;
-(void)setSoundcloudColor:(UIColor *)soundcloudColor;
-(void)setSoundcloudTintColor:(UIColor *)soundcloudTintColor;
-(void)setYoutubeColor:(UIColor *)youtubeColor;
-(void)setYoutubeTintColor:(UIColor *)youtubeTintColor;
-(void)setGoogleColor:(UIColor *)googleColor;
-(void)setGoogleTintColor:(UIColor *)googleTintColor;
-(void)setSpotifyColor:(UIColor *)spotifyColor;
-(void)setSpotifyTintColor:(UIColor *)spotifyTintColor;
-(void)setNavigationColor:(UIColor *)navigationColor;
-(void)setNavigationTintColor:(UIColor *)navigationTintColor;
-(void)setAndroidColor:(UIColor *)androidColor;
-(void)setAndroidTintColor:(UIColor *)androidTintColor;
-(void)setWindowsColor:(UIColor *)windowsColor;
-(void)setWindowsTintColor:(UIColor *)windowsTintColor;
-(void)setInstagramColor:(UIColor *)instagramColor;
-(void)setInstagramTintColor:(UIColor *)instagramTintColor;
-(void)setPhoneColor:(UIColor *)phoneColor;
-(void)setPhoneTintColor:(UIColor *)phoneTintColor;
-(void)setFallbackColor:(UIColor *)fallbackColor;
-(void)setFallbackTintColor:(UIColor *)fallbackTintColor;

-(UIColor *)webColor;
-(UIColor *)webTintColor;
-(UIColor *)mailColor;
-(UIColor *)mailTintColor;
-(UIColor *)wikipediaColor;
-(UIColor *)wikipediaTintColor;
-(UIColor *)itunesColor;
-(UIColor *)itunesTintColor;
-(UIColor *)appleColor;
-(UIColor *)appleTintColor;
-(UIColor *)facebookColor;
-(UIColor *)facebookTintColor;
-(UIColor *)twitterColor;
-(UIColor *)twitterTintColor;
-(UIColor *)shopColor;
-(UIColor *)shopTintColor;
-(UIColor *)linkedInColor;
-(UIColor *)linkedInTintColor;
-(UIColor *)flickrColor;
-(UIColor *)flickrTintColor;
-(UIColor *)soundcloudColor;
-(UIColor *)soundcloudTintColor;
-(UIColor *)youtubeColor;
-(UIColor *)youtubeTintColor;
-(UIColor *)googleColor;
-(UIColor *)googleTintColor;
-(UIColor *)spotifyColor;
-(UIColor *)spotifyTintColor;
-(UIColor *)navigationColor;
-(UIColor *)navigationTintColor;
-(UIColor *)androidColor;
-(UIColor *)androidTintColor;
-(UIColor *)windowsColor;
-(UIColor *)windowsTintColor;
-(UIColor *)instagramColor;
-(UIColor *)instagramTintColor;
-(UIColor *)phoneColor;
-(UIColor *)phoneTintColor;
-(UIColor *)fallbackColor;
-(UIColor *)fallbackTintColor;

@end

@interface XMMContentBlock4TableViewCell (XMMTableViewRepresentation)

- (void)configureForCell:(XMMContentBlock *)block tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath style:(XMMStyle *)style offline:(BOOL)offline;

@end
