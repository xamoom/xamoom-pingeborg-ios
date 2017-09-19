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

  let title: String?
  let subtitle: String?
  let spot : XMMSpot
  let coordinate : CLLocationCoordinate2D
  var distance : Double = 0.0

  init(spot : XMMSpot, userLocation : CLLocation) {
    self.spot = spot
    self.title = spot.name
    self.coordinate = CLLocationCoordinate2D.init(latitude: spot.latitude,
                                                  longitude: spot.longitude)
    self.distance = userLocation.distance(from: CLLocation.init(latitude: spot.latitude,longitude: spot.longitude))
    
    if (distance < 1000.0) {
      self.subtitle = String.localizedStringWithFormat(NSLocalizedString("map.annotation.distance", comment: ""), distance, NSLocalizedString("map.annotation.meter", comment: ""))
    } else {
      self.subtitle = String.localizedStringWithFormat(NSLocalizedString("map.annotation.distance", comment: ""), distance/1000, NSLocalizedString("map.annotation.kilometer", comment: ""))
    }
    
    super.init()
  }
  
  func calcuateDistance(_ pointLocation: CLLocation, userLocation: CLLocation) -> Double {
    return userLocation.distance(from: pointLocation)
  }
  
}
