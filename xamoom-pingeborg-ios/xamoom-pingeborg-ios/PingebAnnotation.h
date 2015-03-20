//
//  PingebAnnotation.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PingebAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property NSString *title;
@property NSString *image;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

- (MKMapItem*)mapItem;

@end
