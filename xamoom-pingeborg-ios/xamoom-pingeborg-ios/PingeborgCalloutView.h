//
//  PingeborgCalloutView.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 20/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PingebAnnotation.h"

@interface PingeborgCalloutView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)button:(id)sender;

@end
