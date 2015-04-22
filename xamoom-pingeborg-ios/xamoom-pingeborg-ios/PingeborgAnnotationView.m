//
//  ^PingeborgAnnotationView.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "PingeborgAnnotationView.h"

@implementation PingeborgAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // The opaque property is YES by default. Setting it to
        // NO allows map content to show through any unrendered parts of your view.
        self.opaque = NO;
        //self.svgImageView = [[SVGKFastImageView alloc] init];
    }
    return self;
}

- (void)displaySVG:(SVGKImage*)image {
    SVGKImageView *svgImageView = [[SVGKFastImageView alloc] initWithSVGKImage:image];
    
    //set svgImageView.frame and image.frame
    float imageRatio = svgImageView.frame.size.width / svgImageView.frame.size.height;
    [svgImageView setFrame:CGRectMake(0.0f, 0.0f, 30.0f*imageRatio, 30.0f)];
    self.frame = svgImageView.frame;
    
    [self addSubview:svgImageView];
}

@end
