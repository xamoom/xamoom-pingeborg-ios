//
//  PingeborgAnnotationView.m
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
        // Set the frame size to the appropriate values.
        CGRect  myFrame = self.frame;
        myFrame.size.width = 400;
        myFrame.size.height = 400;
        self.frame = myFrame;
        
        // The opaque property is YES by default. Setting it to
        // NO allows map content to show through any unrendered parts of your view.
        self.opaque = NO;
    }
    return self;
}


@end
