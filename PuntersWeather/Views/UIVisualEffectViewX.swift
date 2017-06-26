//
//  UIVisualEffectViewX.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

class UIVisualEffectViewX: UIVisualEffectView {
  
  // MARK: - Border
  
  @IBInspectable public var borderColor: UIColor = UIColor.clear {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable public var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable public var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      if cornerRadius > 0 {
        clipsToBounds = true
      } else {
        clipsToBounds = false
      }
    }
  }
}
