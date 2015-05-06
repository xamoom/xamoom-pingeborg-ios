//
//  ^PingeborgAnnotationView.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "PingeborgAnnotationView.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@implementation PingeborgAnnotationView

- (instancetype)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // The opaque property is YES by default. Setting it to
    // NO allows map content to show through any unrendered parts of your view.
    self.opaque = NO;
  }
  return self;
}

- (void)displaySVG:(SVGKImage*)image {
  SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:image];
  
  //set svgImageView.frame and image.frame
  float imageRatio = svgImageView.frame.size.width / svgImageView.frame.size.height;
  
  if (IS_IPHONE_5)
    [svgImageView setFrame:CGRectMake(0.0f, 0.0f, 30.0f*imageRatio, 30.0f)];
  else if (IS_IPHONE_6)
    [svgImageView setFrame:CGRectMake(0.0f, 0.0f, 40.0f*imageRatio, 40.0f)];
  else if (IS_IPHONE_6P)
    [svgImageView setFrame:CGRectMake(0.0f, 0.0f, 50.0f*imageRatio, 50.0f)];
  else
    [svgImageView setFrame:CGRectMake(0.0f, 0.0f, 30.0f*imageRatio, 30.0f)];
  
  self.frame = svgImageView.frame;
  
  [self addSubview:svgImageView];
}

@end
