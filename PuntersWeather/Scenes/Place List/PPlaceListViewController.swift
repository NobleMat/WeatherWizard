//
//  PPlaceListViewController.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright (c) 2017 NTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import CoreData

protocol PPlaceListViewControllerInput {
  func loadData()
}

protocol PPlaceListViewControllerOutput {
  func getWeatherData()
}

class PPlaceListViewController: UIViewController, PPlaceListViewControllerInput {
  var output: PPlaceListViewControllerOutput!
  var router: PPlaceListRouter!
  
  //MARK: - VC Elements
  
  @IBOutlet weak var listCollectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let cellIdentifier = "WeatherCell"
  var weatherItems = [Weather]()
  var filteredItems = [Weather]()
  var isFiltered = false
  let managedContext = CoreDataStack.shared.persistentContainer.viewContext
  var countryList = [String]()
  var weatherList = [String]()
  
  // MARK: - Object lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    PPlaceListConfigurator.sharedInstance.configure(viewController: self)
    
    self.title = "WW"
    self.navigationController?.regularNavigationBar()
    self.automaticallyAdjustsScrollViewInsets = false
    
    //Get weather Deatils
    WeatherActivityIndicator.showActivityIndicator(self.view)
    output.getWeatherData()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    self.searchBar.resignFirstResponder()
  }
  
  // MARK: - Event handling
  func loadData() {
    let weatherDataUpdate: NSFetchRequest<Weather> = Weather.fetchRequest()
    do {
      
      weatherItems = try managedContext.fetch(weatherDataUpdate)
      weatherItems = weatherItems.sorted {
        $0.0.placeName! < $0.1.placeName!
      }
      countryList = weatherItems.flatMap {
        $0.countryDetails?.countryName
      }.unique()
      weatherList = weatherItems.flatMap {
        $0.weatherCondition
      }.unique()
      DispatchQueue.main.async {
        WeatherActivityIndicator.hideActivityIndicator(self.view)
        self.listCollectionView.reloadData()
      }
    } catch {
      print("Error fetching data \(error.localizedDescription)")
    }
  }
  
  lazy var menuView: MenuView = {
    let menu = MenuView()
    menu.homeController = self
    return menu
  }()
  
  @IBAction func filterResults(_ sender: Any) {
    menuView.showSettings(.filter)
  }
  
  @IBAction func refreshList(_ sender: Any) {
    weatherItems = []
    WeatherActivityIndicator.showActivityIndicator(self.view)
    output.getWeatherData()
  }
  
 
  @IBAction func sortList(_ sender: Any) {
    //Show sort menu to figure out way to sort
    menuView.showSettings(.sort)
  }
  
  //MARK: - Sorting Method
  func sortListUsing(_ sortType: SortingTypes) {
    switch sortType {
    case .alphabetically:
      if isFiltered {
        filteredItems = filteredItems.sorted {
          $0.placeName!.localizedCaseInsensitiveCompare($1.placeName!) == ComparisonResult.orderedAscending
        }
      } else {
        weatherItems = weatherItems.sorted {
          $0.placeName!.localizedCaseInsensitiveCompare($1.placeName!) == ComparisonResult.orderedAscending
        }
      }
      break
    case .temperature:
      if isFiltered {
        filteredItems = filteredItems.sorted {
          $0.weatherTemperature < $1.weatherTemperature
        }
      } else {
        weatherItems = weatherItems.sorted {
          $0.weatherTemperature < $1.weatherTemperature
        }
      }
      break
    case .lastUpdated:
      if isFiltered {
        filteredItems = filteredItems.sorted {
          $0.weatherLastUpdated < $1.weatherLastUpdated
        }
      } else {
        weatherItems = weatherItems.sorted {
          $0.weatherLastUpdated < $1.weatherLastUpdated
        }
      }
      break
    default:
      break
    }
    self.listCollectionView.reloadData()
  }
  
  //MARK: - Filtering Method
  func filerListUsing(_ filterType: FilterIngType, filterValue: String) {
    switch filterType {
    case .country:
      filteredItems = weatherItems.filter {
        $0.countryDetails?.countryName == filterValue
      }
      isFiltered = true
      break
    case .weatherCondition:
      filteredItems = weatherItems.filter {
        $0.weatherCondition == filterValue
      }
      isFiltered = true
      break
    case .removeFilter:
      isFiltered = false
      break
    default:
      break
    }
    self.listCollectionView.reloadData()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    menuView.handleBackgroundViewDismiss()
  }
}


//MARK: - CollectionView Delegate
extension PPlaceListViewController: UICollectionViewDelegate {
  
  /**
   The Delegate method to tell the collectionView, what to do when a colectionView
   cell is tapped.
   */
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.alpha = 0
    
    UIView.animate(withDuration: 1.0) { 
      cell.alpha = 1
    }
  }
  
}

//MARK: - CollectionView DataSource
extension PPlaceListViewController: UICollectionViewDataSource {
  
  /**
   Delegate method to set the number of rows per collection
   */
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("count \(weatherItems.count)")
    if isFiltered {
      return filteredItems.count
    }
    return weatherItems.count
  }
  
  /**
   optional Delegate method to set the number of sections
   */
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  /**
   CollectionView DataSource method to set the cell for each item
   */
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PPlaceListCollectionViewCell
    
    var weatherData: Weather!
    if isFiltered {
      weatherData = filteredItems[indexPath.item]
    } else {
      weatherData = weatherItems[indexPath.item]
    }
    
    cell.placeNameLabel.text = weatherData.placeName
    cell.temperatureLabel.text = "\(weatherData.weatherTemperature) ºc"
    cell.lastUpdateLabel.text = "last updated on \(weatherData.weatherLastUpdated.convertToDateString())"
    cell.weatherConditionLabel.text = weatherData.countryDetails?.countryName
    
    return cell
  }
}

extension PPlaceListViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredItems = weatherItems.filter {
      $0.placeName!.contains(searchText)
    }
    isFiltered = true
    self.listCollectionView.reloadData()
    
    if searchText.isEmpty {
      isFiltered = false
      self.listCollectionView.reloadData()
      searchBar.resignFirstResponder()
    }
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
}

extension PPlaceListViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.searchBar.resignFirstResponder()
  }
}
