//
//  PingeborgAnnotationView.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <SVGKit.h>

@interface PingeborgAnnotationView : MKAnnotationView

@property XMMResponseGetSpotMapItem *data;
@property NSString *distance;
@property UIImage *spotImage;
@property CLLocationCoordinate2D coordinate;

/**
 Changes the size of the SVGKImageView according to the device and adds it as a subview
 */
- (void)displaySVG:(SVGKImage*)image;

@end
