//
//  PingebAnnotation.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 13/03/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface PingebAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
