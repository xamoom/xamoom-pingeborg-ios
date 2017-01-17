//
//  MapItemDetailView.swift
//  pingeb.org
//
//  Created by Raphael Seher on 14/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapItemDetailView: UIView {
  
  var view: UIView!
  
  @IBOutlet weak var detailImageView: UIImageView!
  @IBOutlet weak var detailTitleLabel: UILabel!
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var routeButton: UIButton!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  var shownSpot : XMMSpot?
  
  init() {
    super.init(frame: CGRect.null)
    
    nibSetup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    nibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    nibSetup()
  }
  
  fileprivate func nibSetup() {
    backgroundColor = .clear
    
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(view)
  }
  
  fileprivate func loadViewFromNib() -> UIView {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    let nibViews = nib.instantiate(withOwner: self, options: nil)
    
    return nibViews.first as! UIView
  }
  
  @IBAction func didClickRouteButton(_ sender: AnyObject) {
    Analytics.sharedObject().sendEvent(withCategorie: "UX", andAction: "Click", andLabel: "Map Callout Navigation Button", andValue: nil)
    
    if let spot = shownSpot {
      let placemark = MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: spot.latitude, longitude: spot.longitude), addressDictionary: nil)
      let mapItem = MKMapItem.init(placemark: placemark)
      mapItem.name = spot.name
      let launchOptions : [String:String] = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
      mapItem.openInMaps(launchOptions: launchOptions)
    }
  }
  
  func displaySpotInfo(_ spot : XMMSpot) {
    shownSpot = spot
    
    if let imageUrl = spot.image {
      let url : URL = URL(string: imageUrl)!
      imageHeightConstraint.constant = 150
      detailImageView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "placeholder"))
    } else {
      detailImageView.image = nil
      imageHeightConstraint.constant = 0
    }
    
    if let name = spot.name {
      detailTitleLabel.text = name
    } else {
      detailTitleLabel.text = nil
    }
    
    if let description = spot.spotDescription {
      detailDescriptionLabel.text = description
    } else {
      detailDescriptionLabel.text = nil
    }
    
    setNeedsLayout()
  }
}
