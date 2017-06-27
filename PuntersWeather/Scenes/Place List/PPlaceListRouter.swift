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
}

class PPlaceListRouter: PPlaceListRouterInput {
  weak var viewController: PPlaceListViewController!
  
  // MARK: - Navigation
  func passDataToNextScene(segue: UIStoryboardSegue) {
    if segue.identifier == "DetailsSegueIdentifier" {
      var selectedRowIndex = viewController.listCollectionView.indexPathsForSelectedItems?.first!
      let detailsVC:PPlaceDetailsViewController = segue.destination as! PPlaceDetailsViewController
      var weather: Weather?
      if viewController.isFiltered {
        weather = viewController.filteredItems[selectedRowIndex!.item]
      } else {
        weather = viewController.weatherItems[selectedRowIndex!.item]
      }
      detailsVC.weatherDetails = weather
    }
  }
  
}
