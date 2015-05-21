//
//  ContentBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 10/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "ContentBlockTableViewCell.h"

@implementation ContentBlockTableViewCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)initContentBlockWithLanguage:(NSString*)language {
  //creating a unique notification for the contentBlock
  NSString *notificationName = [NSString stringWithFormat:@"%@%@", @"getByIdFull", self.contentId];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(didLoadContentBlockData:)
   name:notificationName
   object:nil];
  
  [[XMMEnduserApi sharedInstance] contentWithContentId:self.contentId includeStyle:NO includeMenu:NO withLanguage:language full:NO];
}

- (void)didLoadContentBlockData:(NSNotification *)notification {
  self.result = [notification object];
  
  //set title and excerpt
  self.contentTitleLabel.text = self.result.content.title;
  self.contentExcerptLabel.text = self.result.content.descriptionOfContent;
  [self.contentExcerptLabel sizeToFit];
  
  //download and display image
  if (self.result.content.imagePublicUrl != nil) {
    [self downloadImageWithURL:self.result.content.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
      if (succeeded && image) {
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.contentImageView.clipsToBounds = YES;
        [self.contentImageView setImage:image];
        
        NSString *notificationName = @"reloadTableViewForContentBlocks";
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
      }
    }];
  }
}

#pragma mark - Image Methods

- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                           {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else{
                             completionBlock(NO,nil);
                           }
                         }];
}

@end
