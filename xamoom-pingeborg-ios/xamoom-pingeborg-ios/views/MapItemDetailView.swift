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
  
  @IBOutlet weak var titleLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let view = loadViewFromNib()
    view.frame = frame;
    addSubview(view)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    if (self.subviews.count == 0) {
      let view = loadViewFromNib()
      view.frame = frame;
      addSubview(view)
    }
  }
  
  func loadViewFromNib() -> UIView {
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "MapItemDetailView", bundle: bundle)
    return nib.instantiateWithOwner(self, options: nil)[0] as! UIView
  }
}
