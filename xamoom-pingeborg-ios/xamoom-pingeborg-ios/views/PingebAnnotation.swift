//
//  PingebAnnotation.swift
//  pingeb.org
//
//  Created by Raphael Seher on 20/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

import UIKit
import CoreLocation

class PingebAnnotation: NSObject, MKAnnotation {

  var spot : XMMSpot
  var coordinate : CLLocationCoordinate2D
  var distance : Double = 0.0

  init(spot : XMMSpot, location : CLLocation) {
    self.spot = spot
    self.coordinate = CLLocationCoordinate2D.init(latitude: spot.latitude,
                                                  longitude: spot.longitude)
    super.init()
    
    self.distance = calcuateDistance(CLLocation.init(latitude: spot.latitude,
      longitude: spot.longitude), userLocation: location)
  }
  
  func calcuateDistance(pointLocation: CLLocation, userLocation: CLLocation) -> Double {
    return userLocation.distanceFromLocation(pointLocation)
  }
  
}
