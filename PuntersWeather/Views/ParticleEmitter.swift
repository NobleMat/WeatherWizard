//
//  ParticleEmitter.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 27/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

class ParticleEmitter {
  static func get(with image: UIImage) -> CAEmitterLayer {
    let emitter = CAEmitterLayer()
    emitter.emitterShape = kCAEmitterLayerLine
    emitter.emitterCells = generateEmitterCells(image: image)
    return emitter
  }
  
  static func generateEmitterCells(image: UIImage) -> [CAEmitterCell] {
    var cells = [CAEmitterCell]()
    
    let cell = CAEmitterCell()
    cell.contents = image
    cell.birthRate = 1
    cell.lifetime = 50
    cell.velocity = CGFloat(25)
    cell.emissionLongitude = (180 * (.pi / 180))
    cell.emissionRange = (45 * (.pi / 180))
    
    cell.scale = 0.4
    cell.scaleRange = 0.2
    
    cells.append(cell)
    
    return cells
  }
}
