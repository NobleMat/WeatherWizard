//
//  MenuView.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 27/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

enum SettingsType: Int {
  case sort = 0
  case filter
}

enum SortingTypes: String {
  case alphabetically = "Sort Alphabetically"
  case temperature = "Sort By temperature"
  case lastUpdated = "Sort by last Updated"
  case cancel = "Cancel"
}

enum FilterIngType: String {
  case country = "Filter By Country"
  case weatherCondition = "Filter By Weather Condition"
  case removeFilter = "Remove Filter"
  case cancel = "Cancel"
}

class MenuView: NSObject {
  
  var homeController: PPlaceListViewController?
  let settingsCellID = "SettingsCell"
  let cellHeight:CGFloat = 50
  var selectedFilterType: FilterIngType?
  var filterStrings = [String]()
  var menuType: SettingsType!
  let sortTypes: [SortingTypes] = [.alphabetically, .temperature, .lastUpdated, .cancel]
  let filterTypes: [FilterIngType] = [.country, .weatherCondition, .removeFilter, .cancel]
  
  lazy var blackBackgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    view.alpha = 0
    return view
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .white
    return cv
  }()
  
  func showSettings(_ menuType: SettingsType) {
    self.menuType = menuType
    if let window = UIApplication.shared.keyWindow {
      blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewDismiss)))
      
      window.addSubview(blackBackgroundView)
      window.addSubview(collectionView)
      
      blackBackgroundView.frame = window.frame
      
      var height: CGFloat = 0
      let maxHeight: CGFloat = 500
      let cellHeight:CGFloat = 50
      switch self.menuType.rawValue {
      case SettingsType.filter.rawValue:
        if let _ = self.selectedFilterType {
          height = CGFloat(filterStrings.count) * cellHeight
        } else {
          height = CGFloat(filterTypes.count) * cellHeight
        }
        break
      case SettingsType.sort.rawValue:
        height = CGFloat(sortTypes.count) * cellHeight
        break
      default:
        break
      }
      let y:CGFloat = window.frame.height - height
      collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: min(height, maxHeight))
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { 
        self.blackBackgroundView.alpha = 1
        self.collectionView.alpha = 1
        self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
      }, completion: nil)
    }
    collectionView.reloadData()
  }
  
  func handleBackgroundViewDismiss() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { 
      self.blackBackgroundView.alpha = 0
      if let window = UIApplication.shared.keyWindow {
        self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        self.collectionView.alpha = 0
      }
    }) { (success: Bool) in
      
    }
    
  }
  
  override init() {
    super.init()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: settingsCellID)
  }
  
}

extension MenuView: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

extension MenuView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch self.menuType.rawValue {
    case SettingsType.filter.rawValue:
      if let selectedFilter = self.selectedFilterType {
        handleBackgroundViewDismiss()
        if let homeVC = homeController {
          homeVC.filerListUsing(selectedFilter, filterValue: filterStrings[indexPath.item])
          self.selectedFilterType = nil
        }
      } else {
        if filterTypes[indexPath.item] != .cancel && filterTypes[indexPath.item] != .removeFilter {
          self.selectedFilterType = filterTypes[indexPath.item]
          
          switch self.selectedFilterType! {
          case .country:
            if let homeVC = homeController {
              filterStrings = homeVC.countryList
            }
            break
          case .weatherCondition:
            if let homeVC = homeController {
              filterStrings = homeVC.weatherList
            }
            break
          default:
            break
          }
          self.collectionView.reloadData()
          if let window = UIApplication.shared.keyWindow {
            let maxHeight: CGFloat = 500
            let cellHeight:CGFloat = 50
            let height: CGFloat = CGFloat(filterStrings.count) * cellHeight
            let y:CGFloat = window.frame.height - min(height, maxHeight)
            collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: min(height, maxHeight))
            
          }
        } else if filterTypes[indexPath.item] == .removeFilter {
          handleBackgroundViewDismiss()
          homeController?.filerListUsing(.removeFilter, filterValue: "")
        } else {
          handleBackgroundViewDismiss()
        }
      }
      break
    case SettingsType.sort.rawValue:
      if sortTypes[indexPath.item] != .cancel {
        handleBackgroundViewDismiss()
        homeController?.sortListUsing(sortTypes[indexPath.item])
      } else {
        handleBackgroundViewDismiss()
      }
      break
    default:
      break
    }
  }
  
}

extension MenuView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingsCellID, for: indexPath) as! SettingsCell
    
    var labelText = ""
    switch self.menuType.rawValue {
    case SettingsType.filter.rawValue:
      if let _ = self.selectedFilterType {
        labelText = filterStrings[indexPath.item]
      } else {
        labelText = filterTypes[indexPath.item].rawValue
      }
      break
    case SettingsType.sort.rawValue:
      labelText = sortTypes[indexPath.item].rawValue
      break
    default:
      break
    }
    cell.nameLabel.text = labelText
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.menuType.rawValue {
    case SettingsType.filter.rawValue:
      if let _ = selectedFilterType {
        return filterStrings.count
      }
      return filterTypes.count
    case SettingsType.sort.rawValue:
      return sortTypes.count
    default:
      break
    }
    return 1
  }
  
}

//MARK: - Custom CollectionView cell
class SettingsCell: UICollectionViewCell {
  
  lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 13)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupCell()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupCell() {
    addSubview(nameLabel)
    
    addConstraintsWithFormat(format: "H:|-10-[v0]|", views: nameLabel)
    addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
  }
  
  override var isHighlighted: Bool {
    didSet {
      backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
      nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
    }
  }
}
