//
//  RadialGradientView.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 28/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

class RadialGradientView: UIView {
  
  @IBInspectable var firstColor: UIColor = UIColor.white
  @IBInspectable var secondColor: UIColor = UIColor.white
  
  override func draw(_ rect: CGRect) {
    let endRadius = min(frame.width, frame.height)
    let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    let gradient = CGGradient(colorsSpace: nil, colors: [firstColor.cgColor, secondColor.cgColor] as CFArray, locations: nil)
    UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 1.5, endCenter: center, endRadius: endRadius, options: .drawsBeforeStartLocation)
  }
}
