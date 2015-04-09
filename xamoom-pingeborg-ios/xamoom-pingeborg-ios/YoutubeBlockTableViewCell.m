//
//  YoutubeBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 09/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "YoutubeBlockTableViewCell.h"

@implementation YoutubeBlockTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initYoutubeVideo {    
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:self.youtubeVideoUrl options:0 range:NSMakeRange(0,self.youtubeVideoUrl.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        NSString* youtubeVideoId = [self.youtubeVideoUrl substringWithRange:result.range];
        [self.playerView loadWithVideoId:youtubeVideoId];
    }
}

@end
