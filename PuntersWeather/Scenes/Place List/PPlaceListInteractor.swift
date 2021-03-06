//
//  PPlaceListInteractor.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright (c) 2017 NTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PPlaceListInteractorInput {
  func getWeatherData()
}

protocol PPlaceListInteractorOutput {
  func updateViews()
}

class PPlaceListInteractor: PPlaceListInteractorInput {
  var output: PPlaceListInteractorOutput!
  var worker: PPlaceListWorker!
  
  // MARK: - Business logic
  
  func getWeatherData() {
    worker = PPlaceListWorker()
    worker.fetchWeatherData { (success) in
      if success {
        self.output.updateViews()
      }
    }
  }
}
