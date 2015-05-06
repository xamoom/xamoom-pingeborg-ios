//
//  MapkitViewController.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 01/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "MapkitViewController.h"

// We need a custom subclass of MKMapView in order to allow touches on UIControls in our custom callout view.
@interface CustomMapView : MKMapView

@property (nonatomic, strong) SMCalloutView *calloutView;

@end

@interface MapkitViewController ()

@property bool isUp;
@property UIImage *placeholder;
@property UISwipeGestureRecognizer *swipeGeoFenceViewUp;
@property UISwipeGestureRecognizer *swipeGeoFenceViewDown;
@property XMMResponseGetByLocationItem *savedResponseContent;

@end

@implementation MapkitViewController




#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //init map
  self.mapKitWithSMCalloutView = [[CustomMapView alloc] initWithFrame:self.mapView.bounds];
  self.mapKitWithSMCalloutView.delegate = self;
  self.mapKitWithSMCalloutView.showsUserLocation = YES;
  [self.mapView addSubview:self.mapKitWithSMCalloutView];
  
  //setting up tableView
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  self.tableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 150.0;
  
  //add shadow to geofenceView
  CALayer *layer = self.geofenceView.layer;
  layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  layer.shadowColor = [[UIColor blackColor] CGColor];
  layer.shadowRadius = 4.0f;
  layer.shadowOpacity = 0.20f;
  layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
  
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
  if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    [self.locationManager requestWhenInUseAuthorization];
  }
  
  [self.geoFenceActivityIndicator startAnimating];
  [[XMMEnduserApi sharedInstance] setDelegate:self];
  [[XMMEnduserApi sharedInstance] spotMapWithSystemId:[Globals sharedObject].globalSystemId withMapTags:@"showAllTheSpots" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
  
  self.placeholder = [UIImage imageNamed:@"placeholder"];
  self.isUp = NO;
}

-(void)viewDidAppear:(BOOL)animated {
  self.locationManager.distanceFilter = kCLDistanceFilterNone;
  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [self.locationManager startUpdatingLocation];
  
  //map region
  MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
  region.center.latitude = 46.6247222;
  region.center.longitude = 14.3052778;
  region.span.longitudeDelta = 0.09f;
  region.span.longitudeDelta = 0.09f;
  [self.mapKitWithSMCalloutView setRegion:region animated:YES];
  
  //create userTracking button
  MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapKitWithSMCalloutView];
  self.parentViewController.navigationItem.rightBarButtonItem = buttonItem;
  
  if ( self.mapKitWithSMCalloutView.annotations.count <= 0 ) {
    [self.geoFenceActivityIndicator startAnimating];
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] spotMapWithSystemId:[Globals sharedObject].globalSystemId withMapTags:@"showAllTheSpots" withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
  }
}

-(void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - XMMEnduser Delegate

- (void)didLoadSpotMap:(XMMResponseGetSpotMap *)result {
  if (result.style.customMarker != nil) {
    NSString *base64String = result.style.customMarker;
    
    //decode two times!
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    decodedData = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [self imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
    
    if (!self.customMapMarker) {
      //save svg mapmarker
      NSArray *paths = NSSearchPathForDirectoriesInDomains
      (NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentsDirectory = paths[0];
      NSString *fileName = [NSString stringWithFormat:@"%@/mapmarker.svg", documentsDirectory];
      [imageData writeToFile:fileName atomically:YES];
      
      //read svg mapmarker
      NSData *data = [[NSFileManager defaultManager] contentsAtPath:fileName];
      self.customSVGMapMarker = [SVGKImage imageWithSource:[SVGKSourceString sourceFromContentsOfString:
                                                            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]];
    }
  }
  
  for (XMMResponseGetSpotMapItem *item in result.items) {
    // Add an annotation
    PingebAnnotation *point = [[PingebAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake(item.lat, item.lon)];
    point.data = item;
    
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    point.distance = [NSString stringWithFormat:@"Distance: %d meter", (int)distance];
    
    [self.mapKitWithSMCalloutView addAnnotation:point];
  }
  
  [XMMEnduserApi sharedInstance].delegate = self;
  [[XMMEnduserApi sharedInstance] contentWithLat:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.latitude] withLon:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.longitude] withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
}

-(void)didLoadDataWithLocation:(XMMResponseGetByLocation *)result {
  NSString *savedArtists = [Globals savedArtits];
  self.itemsToDisplay = [[NSMutableArray alloc] init];
  self.imagesToDisplay = [[NSMutableDictionary alloc] init];
  
  if([result.items firstObject] != nil) {
    XMMResponseGetByLocationItem* item = [result.items firstObject];
    self.savedResponseContent = item;
    
    //set geoFenceLabel
    self.geoFenceLabel.text = [NSString stringWithFormat:@"Gefunden: %@", item.title];
    
    if ([item.systemId isEqualToString:[Globals sharedObject].globalSystemId]) {
      [self.itemsToDisplay addObject:item];
      
      if ([item.imagePublicUrl containsString:@".gif"]) {
        //off mainthread gifimage loading
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
          UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:item.imagePublicUrl]];
          
          dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (![savedArtists containsString:item.contentId]) {
              UIImage *grayscaleImage = [self convertImageToGrayScale:gifImage];
              [self.imagesToDisplay setValue:grayscaleImage forKey:item.contentId];
            } else {
              [self.imagesToDisplay setValue:gifImage forKey:item.contentId];
            }
            
            [self enableGeofenceView];
          });
        });
      } else if(item.imagePublicUrl != nil) {
        [self downloadImageWithURL:item.imagePublicUrl completionBlock:^(BOOL succeeded, UIImage *image) {
          if (succeeded) {
            if (![savedArtists containsString:item.contentId]) {
              image = [self convertImageToGrayScale:image];
            }
            
            [self.imagesToDisplay setValue:image forKey:item.contentId];
            [self.tableView reloadData];

            [self enableGeofenceView];
          }
        }];
      } else {
        [self.imagesToDisplay setValue:self.placeholder forKey:item.contentId];
        
        [self enableGeofenceView];
      }
    }
  }

  if (self.savedResponseContent == nil) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [XMMEnduserApi sharedInstance].delegate = self;
    [[XMMEnduserApi sharedInstance] closestSpotsWith:self.lastLocation.coordinate.latitude andLon:self.lastLocation.coordinate.longitude withRadius:30000 withLimit:10 withLanguage:[XMMEnduserApi sharedInstance].systemLanguage];
  }
}

- (void)didLoadClosestSpots:(XMMResponseClosestSpot *)result {
  for (XMMResponseGetSpotMapItem *item in result.items) {
    [self.itemsToDisplay addObject:item];
  }
  
  if ([self.itemsToDisplay count] > 0) {
    self.geoFenceLabel.text = [NSString stringWithFormat:@"%lu in der Nähe", (unsigned long)[self.itemsToDisplay count]];
    [self enableGeofenceView];
  } else {
    self.geoFenceLabel.text = @"Nichts in deiner Nähe";
  }
}

#pragma mark - MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  //do not touch userLocation
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  if ([annotation isKindOfClass:[PingebAnnotation class]]) {
    static NSString *identifier = @"PingebAnnotation";
    PingeborgAnnotationView *annotationView;
    if (annotationView == nil) {
      annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
      annotationView.enabled = YES;
      annotationView.canShowCallout = NO;
      
      //set mapmarker
      if(self.customMapMarker) {
        annotationView.image = self.customMapMarker;
      } else if (self.customSVGMapMarker) {
        [annotationView displaySVG:self.customSVGMapMarker];
      } else {
        annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
      }
      
      PingebAnnotation *pingebAnnotation = (PingebAnnotation*)annotation;
      annotationView.data = pingebAnnotation.data;
      annotationView.distance = pingebAnnotation.distance;
      annotationView.coordinate = pingebAnnotation.coordinate;
      
      //gif support
      if ([pingebAnnotation.data.image containsString:@".gif"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
          UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:pingebAnnotation.data.image]];
          
          dispatch_async(dispatch_get_main_queue(), ^(void) {
            annotationView.spotImage = gifImage;
          });
        });
      } else if(pingebAnnotation.data.image != nil) {
        [self downloadImageWithURL:pingebAnnotation.data.image completionBlock:^(BOOL succeeded, UIImage *image) {
          if (succeeded) {
            annotationView.spotImage = image;
          }
        }];
      }
      
    } else {
      annotationView.annotation = annotation;
    }
    
    return annotationView;
  }
  
  return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
  
  // create our custom callout view
  SMCalloutView *calloutView = [SMCalloutView platformCalloutView];
  calloutView.delegate = self;
  [calloutView setContentViewInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  self.mapKitWithSMCalloutView.calloutView = calloutView;
  
  if ([annotationView isKindOfClass:[PingeborgAnnotationView class]]) {
    PingeborgAnnotationView* pingeborgAnnotationView = (PingeborgAnnotationView *)annotationView;
    PingeborgCalloutView* pingeborgCalloutView = [[PingeborgCalloutView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 35.0f)];
    pingeborgCalloutView.nameOfSpot = pingeborgAnnotationView.data.displayName;
    
    //create titleLabel
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 280.0f, 25.0f)];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = pingeborgAnnotationView.data.displayName;
    
    //size label to fit content
    CGRect titleLabelRect = titleLabel.frame;
    titleLabelRect.size = [titleLabel sizeThatFits:titleLabelRect.size];
    titleLabel.frame = titleLabelRect;
    
    [pingeborgCalloutView addSubview:titleLabel];
    
    //increase pingeborCalloutView height
    CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
    pingeborgCalloutViewRect.size.height += titleLabel.frame.size.height;
    pingeborgCalloutView.frame = pingeborgCalloutViewRect;
    
    //create distance label
    UILabel* distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, titleLabel.frame.size.height + 10.0f, 280.0f, 25.0f)];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = pingeborgAnnotationView.distance;
    
    //set coordinates (for navigating)
    pingeborgCalloutView.coordinate = pingeborgAnnotationView.coordinate;
    
    
    [pingeborgCalloutView addSubview:distanceLabel];
    
    UIImageView *spotImageView;
    
    //insert image
    if(pingeborgAnnotationView.spotImage != nil) {
      if (pingeborgAnnotationView.spotImage.size.width < pingeborgAnnotationView.spotImage.size.height) {
        spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, pingeborgCalloutView.frame.size.width, pingeborgCalloutView.frame.size.width)];
      } else {
        float imageRatio = pingeborgAnnotationView.spotImage.size.width / pingeborgAnnotationView.spotImage.size.height;
        spotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height, pingeborgCalloutView.frame.size.width, pingeborgCalloutView.frame.size.width / imageRatio)];
      }
      
      [spotImageView setContentMode: UIViewContentModeScaleToFill];
      spotImageView.image = pingeborgAnnotationView.spotImage;
      
      //increase pingeborCalloutView height
      CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
      pingeborgCalloutViewRect.size.height += spotImageView.frame.size.height;
      pingeborgCalloutView.frame = pingeborgCalloutViewRect;
      
      [pingeborgCalloutView addSubview:spotImageView];
    }
    
    if (![pingeborgAnnotationView.data.descriptionOfSpot isEqualToString:@""]) {
      UILabel *spotDescriptionLabel;
      if ([pingeborgCalloutView.subviews count] >= 3) {
        spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, spotImageView.frame.size.height + spotImageView.frame.origin.y + 5.0f, 280.0f, 25.0f)];
      } else {
        spotDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, distanceLabel.frame.origin.y + distanceLabel.frame.size.height + 5.0f, 280.0f, 25.0f)];
      }
      
      spotDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
      spotDescriptionLabel.numberOfLines = 0;
      spotDescriptionLabel.font = [UIFont systemFontOfSize:12];
      spotDescriptionLabel.textColor = [UIColor darkGrayColor];
      spotDescriptionLabel.text = pingeborgAnnotationView.data.descriptionOfSpot;
      
      //resize label depending on content
      CGRect spotDescriptionLabelRect = spotDescriptionLabel.frame;
      spotDescriptionLabelRect.size = [spotDescriptionLabel sizeThatFits:spotDescriptionLabelRect.size];
      spotDescriptionLabel.frame = spotDescriptionLabelRect;
      
      //increase pingeborCalloutView height
      CGRect pingeborgCalloutViewRect = pingeborgCalloutView.frame;
      pingeborgCalloutViewRect.size.height += spotDescriptionLabel.frame.size.height + 10.0f;
      pingeborgCalloutView.frame = pingeborgCalloutViewRect;
      
      [pingeborgCalloutView addSubview:spotDescriptionLabel];
    }
    
    //create, design and adjust button
    UIButton *navigationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, pingeborgCalloutView.frame.size.height, 300.0f, 60.0f)];
    navigationButton.backgroundColor = [Globals sharedObject].pingeborgLinkColor;
    [navigationButton setImage:[[UIImage imageNamed:@"car"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    navigationButton.tintColor = [UIColor whiteColor];
    [navigationButton setImageEdgeInsets: UIEdgeInsetsMake(-10.0f, navigationButton.titleEdgeInsets.right, 10.0f, navigationButton.titleEdgeInsets.left)];
    
    //increase pingeborCalloutView height
    pingeborgCalloutViewRect = pingeborgCalloutView.frame;
    pingeborgCalloutViewRect.size.height += navigationButton.frame.size.height - 20.0f;
    pingeborgCalloutView.frame = pingeborgCalloutViewRect;
    
    [navigationButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapNavigationTapped)]];
    
    [pingeborgCalloutView addSubview:navigationButton];
    
    //set custom contentView
    calloutView.contentView = pingeborgCalloutView;
    
    // Apply the MKAnnotationView's desired calloutOffset (from the top-middle of the view)
    calloutView.calloutOffset = annotationView.calloutOffset;
    
    // iOS 7 only: Apply our view controller's edge insets to the allowable area in which the callout can be displayed.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
      calloutView.constrainedInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
    
    [calloutView presentCalloutFromRect:annotationView.bounds inView:annotationView constrainedToView:self.mapView animated:YES];
  }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  [self.mapKitWithSMCalloutView.calloutView dismissCalloutAnimated:YES];
}

//
// SMCalloutView delegate methods
//

- (NSTimeInterval)calloutView:(SMCalloutView *)calloutView delayForRepositionWithSize:(CGSize)offset {
  
  // When the callout is being asked to present in a way where it or its target will be partially offscreen, it asks us
  // if we'd like to reposition our surface first so the callout is completely visible. Here we scroll the map into view,
  // but it takes some math because we have to deal in lon/lat instead of the given offset in pixels.
  
  CLLocationCoordinate2D coordinate = self.mapKitWithSMCalloutView.centerCoordinate;
  
  // where's the center coordinate in terms of our view?
  CGPoint center = [self.mapKitWithSMCalloutView convertCoordinate:coordinate toPointToView:self.mapView];
  
  // move it by the requested offset
  center.x -= offset.width;
  center.y -= offset.height;
  
  // and translate it back into map coordinates
  coordinate = [self.mapKitWithSMCalloutView convertPoint:center toCoordinateFromView:self.mapView];
  
  // move the map!
  [self.mapKitWithSMCalloutView setCenterCoordinate:coordinate animated:YES];
  
  // tell the callout to wait for a while while we scroll (we assume the scroll delay for MKMapView matches UIScrollView)
  return kSMCalloutViewRepositionDelayForUIScrollView;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  self.lastLocation = [locations lastObject];
}

#pragma mark User Interaction

- (void)mapNavigationTapped {
  PingeborgCalloutView *pingeborgCalloutView = (PingeborgCalloutView* )self.mapKitWithSMCalloutView.calloutView.contentView;
  
  MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pingeborgCalloutView.coordinate addressDictionary:nil];
  
  MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
  mapItem.name = pingeborgCalloutView.nameOfSpot;
  
  NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
  [mapItem openInMapsWithLaunchOptions:launchOptions];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.itemsToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  if ([self.itemsToDisplay[indexPath.row] isKindOfClass:[XMMResponseGetByLocationItem class]]) {
    FeedItemCell *cell = (FeedItemCell *)[self.tableView dequeueReusableCellWithIdentifier:@"FeedItemCell"];
    if (cell == nil)
    {
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FeedItemCell" owner:self options:nil];
      cell = nib[0];
    }
    [cell.loadingIndicator startAnimating];
    
    XMMResponseGetByLocationItem *item = self.itemsToDisplay[indexPath.row];
    cell.feedItemTitle.text = item.title;
    cell.contentId = item.contentId;
    
    if (self.imagesToDisplay[item.contentId] == self.placeholder) {
      UIImage *image = self.imagesToDisplay[item.contentId];
      float imageRatio = image.size.width / image.size.height;
      [cell.imageHeightConstraint setConstant:(cell.frame.size.width / imageRatio)];
      cell.feedItemImage.image = image;
      [cell.loadingIndicator stopAnimating];
    } else if (self.imagesToDisplay[item.contentId]){
      UIImage *image = self.imagesToDisplay[item.contentId];
      float imageRatio = image.size.width / image.size.height;
      [cell.imageHeightConstraint setConstant:(cell.frame.size.width / imageRatio)];
      cell.feedItemImage.image = image;
      [cell.loadingIndicator stopAnimating];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openArtistDetailViewFromSender:)];
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"LocationItem" forIndexPath:indexPath];
    
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LocationItem"];
    }
    
    XMMResponseGetSpotMapItem *item = self.itemsToDisplay[indexPath.row];
    cell.textLabel.text = item.displayName;
    
    CLLocation *pointLocation = [[CLLocation alloc] initWithLatitude:item.lat longitude:item.lon];
    CLLocationDistance distance = [self.locationManager.location distanceFromLocation:pointLocation];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %d meter", (int)distance];
    
    //make cell transparent
    [[cell contentView] setBackgroundColor:[UIColor clearColor]];
    [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  
  return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Image Methods

- (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
  CGFloat oldWidth = image.size.width;
  CGFloat oldHeight = image.size.height;
  
  CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
  
  CGFloat newHeight = oldHeight * scaleFactor;
  CGFloat newWidth = oldWidth * scaleFactor;
  CGSize newSize = CGSizeMake(newWidth, newHeight);
  
  return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
  } else {
    UIGraphicsBeginImageContext(size);
  }
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
  // Create image rectangle with current image width/height
  CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
  
  // Grayscale color space
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
  
  // Create bitmap content with current image size and grayscale colorspace
  CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
  
  // Draw image into current context, with specified rectangle
  // using previously defined context (with grayscale colorspace)
  CGContextDrawImage(context, imageRect, [image CGImage]);
  
  // Create bitmap image info from pixel data in current context
  CGImageRef imageRef = CGBitmapContextCreateImage(context);
  
  // Create a new UIImage object
  UIImage *newImage = [UIImage imageWithCGImage:imageRef];
  
  // Release colorspace, context and bitmap information
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
  CFRelease(imageRef);
  
  // Return the new grayscale image
  return newImage;
}


- (void)downloadImageWithURL:(NSString *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
  NSURL *realUrl = [[NSURL alloc]initWithString:url];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:realUrl];
  [NSURLConnection sendAsynchronousRequest:request
                                     queue:[NSOperationQueue mainQueue]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if ( !error )
                           {
                             UIImage *image = [[UIImage alloc] initWithData:data];
                             completionBlock(YES,image);
                           } else{
                             completionBlock(NO,nil);
                           }
                         }];
}

#pragma mark - NavbarDropdown Delegation

- (void)pingeborgSystemChanged {
  NSLog(@"pingeborgSystemChanged");
}

#pragma mark - GeoFencing UI/UX

- (IBAction)openGeoFencing:(UIButton *)sender {
  [self toggleGeoFenceView];
}

- (void)enableGeofenceView {
  self.geoFenceIcon.image = [UIImage imageNamed:@"angleDown"];
  self.geoFenceIcon.transform = CGAffineTransformMakeRotation(M_PI);
  [self.geoFenceActivityIndicator stopAnimating];
  [self.tableView reloadData];
  
  self.swipeGeoFenceViewUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewUp.direction = UISwipeGestureRecognizerDirectionUp;
  self.swipeGeoFenceViewDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  self.swipeGeoFenceViewDown.direction = UISwipeGestureRecognizerDirectionDown;
  UITapGestureRecognizer *geoFenceTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleGeoFenceView)];
  [self.geofenceView addGestureRecognizer:geoFenceTapGesture];
  [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewUp];
  
  [self.geoFenceActivityIndicator stopAnimating];
  self.geoFenceIcon.image = [UIImage imageNamed:@"angleDown"];
  self.geoFenceIcon.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)toggleGeoFenceView {
  [self.view layoutIfNeeded];
  
  if (self.isUp) {
    self.tableViewHeightConstraint.constant = 0.0f;
    [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewDown];
    [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewUp];
  } else {
    if (self.savedResponseContent != nil) {
      UIImage *image = self.imagesToDisplay[self.savedResponseContent.contentId];
      float imageRatio = image.size.width / image.size.height;
      self.tableViewHeightConstraint.constant = (self.tableView.frame.size.width / imageRatio);
      self.tableView.scrollEnabled = NO;
      self.tableView.bounces = NO;
    } else {
      self.tableViewHeightConstraint.constant = (self.view.frame.size.height/2) + 40;
    }
    
    [self.geofenceView removeGestureRecognizer:self.swipeGeoFenceViewUp];
    [self.geofenceView addGestureRecognizer:self.swipeGeoFenceViewDown];
  }
  
  [UIView animateWithDuration:0.5
                   animations:^{
                     if (self.isUp)
                       self.geoFenceIcon.transform = CGAffineTransformMakeRotation(M_PI);
                     else
                       self.geoFenceIcon.transform = CGAffineTransformMakeRotation(0);
                     [self.view layoutIfNeeded]; // Called on parent view
                     self.isUp = !self.isUp;
                   }];
  
  if (self.isUp)
    [self.tableView reloadData];

}

- (void)openArtistDetailViewFromSender:(UITapGestureRecognizer*)sender {
  FeedItemCell *cell = (FeedItemCell*)sender.view;
  ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] init];
  artistDetailViewController.contentId = cell.contentId;
  [self.navigationController pushViewController:artistDetailViewController animated:YES];
}

@end

//
// Custom Map View
//
// We need to subclass MKMapView in order to present an SMCalloutView that contains interactive
// elements.
//

@interface MKMapView (UIGestureRecognizer)

// this tells the compiler that MKMapView actually implements this method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end

@implementation CustomMapView

// override UIGestureRecognizer's delegate method so we can prevent MKMapView's recognizer from firing
// when we interact with UIControl subclasses inside our callout view.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if ([touch.view isKindOfClass:[UIControl class]])
    return NO;
  else
    return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
}

// Allow touches to be sent to our calloutview.
// See this for some discussion of why we need to override this: https://github.com/nfarina/calloutview/pull/9
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  UIView *calloutMaybe = [self.calloutView hitTest:[self.calloutView convertPoint:point fromView:self] withEvent:event];
  if (calloutMaybe) return calloutMaybe;
  
  return [super hitTest:point withEvent:event];
}

@end
