//
//  GradientBackgroundView.swift
//  pingeb.org
//
//  Created by Raphael Seher on 14/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
  
  let gradientLayer : CAGradientLayer = CAGradientLayer()
  var firstColor : UIColor {
    didSet {
      updateBackgroundGradient()
    }
  }
  var secondColor : UIColor {
    didSet {
      updateBackgroundGradient()
    }
  }
  var opacity : Float {
    didSet {
      updateBackgroundGradient()
    }
  }
  
  init() {
    firstColor = UIColor.clearColor()
    secondColor = UIColor.clearColor()
    opacity = 1.0
    
    super.init(frame: CGRectNull)
    
    self.layer.insertSublayer(gradientLayer, atIndex: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    firstColor = UIColor.clearColor()
    secondColor = UIColor.clearColor()
    opacity = 1.0
    
    super.init(coder: aDecoder)
    
    self.layer.insertSublayer(gradientLayer, atIndex: 0)
  }
  
  required override init(frame: CGRect) {
    firstColor = UIColor.clearColor()
    secondColor = UIColor.clearColor()
    opacity = 1.0
    
    super.init(frame: frame)
  
    self.bounds = frame
    self.layer.insertSublayer(gradientLayer, atIndex: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.gradientLayer.frame = self.bounds
  }
  
  func updateBackgroundGradient() {
    gradientLayer.frame = self.bounds
    gradientLayer.colors = [firstColor.CGColor, secondColor.CGColor]
    gradientLayer.opacity = opacity
  }
  
}
