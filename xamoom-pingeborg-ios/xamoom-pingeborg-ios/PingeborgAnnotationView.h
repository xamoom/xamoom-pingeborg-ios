//
//  PingeborgAnnotationView.h
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 19.03.15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"

@interface PingeborgAnnotationView : MKAnnotationView

@property XMMResponseGetSpotMapItem *data;
@property NSString *distance;

@end
