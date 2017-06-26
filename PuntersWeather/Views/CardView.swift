//
//  CardView.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 2
  
  @IBInspectable var shadowOffsetWidth: Int = 0
  @IBInspectable var shadowOffsetHeight: Int = 3
  @IBInspectable var shadowColor: UIColor? = UIColor.black
  @IBInspectable var shadowOpacity: Float = 0.5
  @IBInspectable var needsShadow: Bool = false
  
  override func layoutSubviews() {
    layer.cornerRadius = cornerRadius
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    
    if needsShadow {
      layer.masksToBounds = false
      layer.shadowColor = shadowColor?.cgColor
      layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
      layer.shadowOpacity = shadowOpacity
      layer.shadowPath = shadowPath.cgPath
    }
  }
  
}
