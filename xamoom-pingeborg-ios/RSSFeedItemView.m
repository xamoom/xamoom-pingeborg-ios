//
//  RSSFeedItemView.m
//  
//
//  Created by Raphael Seher on 10/03/15.
//
//

#import "RSSFeedItemView.h"

@implementation RSSFeedItemView

@synthesize delegate;

- (instancetype)init {
    self.frame = CGRectMake(0, 0, self.frame.size.width, 200.0f);
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

}
*/

- (IBAction)viewTouched:(id)sender {
    if ( [delegate respondsToSelector:@selector(touchedRSSFeedItem:)] ) {
        [delegate performSelector:@selector(touchedRSSFeedItem:) withObject:self.rssEntry];
    }
}



@end
