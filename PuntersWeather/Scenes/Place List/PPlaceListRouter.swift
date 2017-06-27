//
//  PPlaceListRouter.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright (c) 2017 NTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol PPlaceListRouterInput {
  func navigateToDetailsPage()
}

class PPlaceListRouter: PPlaceListRouterInput {
  weak var viewController: PPlaceListViewController!
  
  // MARK: - Navigation
  
  func navigateToDetailsPage() {
    // Storyboard segue to Details VC
    viewController.performSegue(withIdentifier: "", sender: nil)
  }
  
}