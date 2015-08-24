//
// Copyright 2015 by xamoom GmbH <apps@xamoom.com>
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
// along with xamoom-pingeborg-ios. If not, see <http://www.gnu.org/licenses/>.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SVGKit.h>
#import <SVGKSourceString.h>
#import <REMenu/REMenu.h>
#import <xamoom-ios-sdk/XMMAnnotationView.h>
#import <xamoom-ios-sdk/XMMCalloutView.h>
#import "SMCalloutView.h"
#import "FeedItemCell.h"
#import "ArtistDetailViewController.h"

@class PingeborgMapView;

@interface MapkitViewController : UIViewController <MKMapViewDelegate, SMCalloutViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *geofenceView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *geoFenceActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *geoFenceIcon;
@property (weak, nonatomic) IBOutlet UILabel *geoFenceLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIView *instructionView;

@property (nonatomic, strong) PingeborgMapView *mapKitWithSMCalloutView;
@property (nonatomic, strong) MKPointAnnotation *annotationForSMCalloutView;

@property CLLocationManager *locationManager;
@property CLLocation *lastLocation;

@property UIImage *customMapMarker;
@property SVGKImage *customSVGMapMarker;
@property NSMutableArray *itemsToDisplay;
@property NSMutableDictionary *imagesToDisplay;

@end
