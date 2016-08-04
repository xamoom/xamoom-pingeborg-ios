//
// Copyright 2016 by xamoom GmbH <apps@xamoom.com>
//
// This file is part of some open source application.
//
// Some open source application is free software: you can redistribute
// it and/or modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation, either
// version 2 of the License, or (at your option) any later version.
//
// Some open source application is distributed in the hope that it will
// be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with xamoom-ios-sdk. If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "XMMEnduserApi.h"

@class XMMSpot;

/**
 * XMMAnnotation will be used to by XMMContentBlock9TableViewCell to create the map annotations.
 */
@interface XMMAnnotation : NSObject <MKAnnotation>

@property XMMSpot *spot;
@property NSString *distance;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString*)name withLocation:(CLLocationCoordinate2D)coord NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) MKMapItem *mapItem;

@end
