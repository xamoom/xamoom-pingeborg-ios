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
    super.init(frame: CGRectNull)
    
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
  
  private func nibSetup() {
    backgroundColor = .clearColor()
    
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    view.translatesAutoresizingMaskIntoConstraints = true
    
    addSubview(view)
  }
  
  private func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
    let nibViews = nib.instantiateWithOwner(self, options: nil)
    
    return nibViews.first as! UIView
  }
  
  @IBAction func didClickRouteButton(sender: AnyObject) {
    Analytics.sharedObject().sendEventWithCategorie("UX", andAction: "Click", andLabel: "Map Callout Navigation Button", andValue: nil)
    
    if let spot = shownSpot {
      let placemark = MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: spot.latitude, longitude: spot.longitude), addressDictionary: nil)
      let mapItem = MKMapItem.init(placemark: placemark)
      mapItem.name = spot.name
      let launchOptions : [String:String] = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
      mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
  }
  
  func displaySpotInfo(spot : XMMSpot) {
    shownSpot = spot
    
    if let imageUrl = spot.image {
      let url : NSURL = NSURL(string: imageUrl)!
      imageHeightConstraint.constant = 150
      detailImageView.sd_setImageWithURL(url, placeholderImage: UIImage.init(named: "placeholder"))
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
