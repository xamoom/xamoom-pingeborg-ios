//
//  RSSFeedItemView.h
//  
//
//  Created by Raphael Seher on 10/03/15.
//
//

#import <UIKit/UIKit.h>

@protocol RSSFeedItemViewDelegate <NSObject>

@optional

- (void)touchedRSSFeedItem;

@end

@interface RSSFeedItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property id<RSSFeedItemViewDelegate> delegate;

- (IBAction)viewTouched:(id)sender;

@end
