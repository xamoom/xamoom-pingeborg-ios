//
//  GradientBackgroundView.swift
//  pingeb.org
//
//  Created by Raphael Seher on 14/06/16.
//  Copyright © 2016 xamoom GmbH. All rights reserved.
//

import Foundation
import UIKit

@objc
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
    firstColor = UIColor.clear
    secondColor = UIColor.clear
    opacity = 1.0
    
    super.init(frame: CGRect.null)
    
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    firstColor = UIColor.clear
    secondColor = UIColor.clear
    opacity = 1.0
    
    super.init(coder: aDecoder)
    
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  required override init(frame: CGRect) {
    firstColor = UIColor.clear
    secondColor = UIColor.clear
    opacity = 1.0
    
    super.init(frame: frame)
  
    self.bounds = frame
    self.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.gradientLayer.frame = self.bounds
  }
  
  func updateBackgroundGradient() {
    gradientLayer.frame = self.bounds
    gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
    gradientLayer.opacity = opacity
  }
  
}
