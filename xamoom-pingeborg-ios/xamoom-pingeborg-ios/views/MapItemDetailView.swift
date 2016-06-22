//
//  MapItemDetailView.swift
//  pingeb.org
//
//  Created by Raphael Seher on 14/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

import Foundation
import UIKit

class MapItemDetailView: UIView {
  
  var view: UIView!
  
  @IBOutlet weak var detailImageView: UIImageView!
  @IBOutlet weak var detailTitleLabel: UILabel!
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
  
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
  }
  
  @IBAction func didClickOpenButton(sender: AnyObject) {
  }
  
  func displaySpotInfo(spot : XMMSpot) {
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
