//
//  SpotMapBlockTableViewCell.m
//  xamoom-pingeborg-ios
//
//  Created by Raphael Seher on 15/04/15.
//  Copyright (c) 2015 xamoom GmbH. All rights reserved.
//

#import "SpotMapBlockTableViewCell.h"

@implementation SpotMapBlockTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getSpotMap {
    self.map.delegate = self;
    [[XMMEnduserApi sharedInstance] setDelegate:self];
    [[XMMEnduserApi sharedInstance] getSpotMapWithSystemId:@"6588702901927936" withMapTags:self.spotMapTags withLanguage:@"de"];
}

#pragma mark - XMMEnduser Delegate
- (void)didLoadDataBySpotMap:(XMMResponseGetSpotMap *)result {
    NSString *base64String = result.style.customMarker;
    
    //decode two times!
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    decodedData = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:decodedString]];
    self.customMapMarker = [self imageWithImage:[UIImage imageWithData:imageData] scaledToMaxWidth:30.0f maxHeight:30.0f];
    
    for (XMMResponseGetSpotMapItem *item in result.items) {
        // Add an annotation
        PingebAnnotation *point = [[PingebAnnotation alloc] initWithName:item.displayName location:CLLocationCoordinate2DMake([item.lat doubleValue], [item.lon doubleValue])];
        point.data = item;
        
        [self.map addAnnotation:point];
    }
    
    [self zoomMapViewToFitAnnotations:self.map animated:YES];
}

#pragma mark MKMapView delegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[PingebAnnotation class]]) {
        static NSString *identifier = @"PingebAnnotation";
        PingeborgAnnotationView *annotationView = (PingeborgAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[PingeborgAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            
            if(self.customMapMarker == nil) {
                annotationView.image = [UIImage imageNamed:@"mappoint"];//here we use a nice image instead of the default pins
            } else {
                annotationView.image = self.customMapMarker;
            }
            
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = [self.map.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

#pragma mark imageutility
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

@end