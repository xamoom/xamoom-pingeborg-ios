//
//  RSSFeedItemView.h
//  
//
//  Created by Raphael Seher on 10/03/15.
//
//

#import <UIKit/UIKit.h>
#import "XMMRSSEntry.h"

@protocol RSSFeedItemViewDelegate <NSObject>

@optional

- (void)touchedRSSFeedItem:(XMMRSSEntry*)rssEntry;

@end

@interface RSSFeedItemView : UIView

@property XMMRSSEntry* rssEntry;
@property id<RSSFeedItemViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (IBAction)viewTouched:(id)sender;

@end
