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

enum SortingTypes: Int {
  case alphabetically = 0
  case temperature
  case lastUpdated
}

enum FilterIngType: Int {
  
}

class MenuView: NSObject {
  
  var homeController: PPlaceListViewController?
  let settingsCellID = "SettingsCell"
  let cellHeight:CGFloat = 50
  var menuType: SettingsType!
  let sortTypes = ["Sort Alphabetically", "Sort By temperature", "Sort by last Updated", "Cancel"]
  let filterTypes = ["Filter By Country", "Filter By WEather Condition", "Cancel"]
  
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
      blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewDismiss(_:))))
      
      window.addSubview(blackBackgroundView)
      window.addSubview(collectionView)
      
      blackBackgroundView.frame = window.frame
      
      var height: CGFloat = 0
      let maxHeight: CGFloat = 500
      let cellHeight:CGFloat = 50
      switch self.menuType.rawValue {
      case SettingsType.filter.rawValue:
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
        self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
      }, completion: nil)
    }
  }
  
  func handleBackgroundViewDismiss(_ recogniser: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { 
      self.blackBackgroundView.alpha = 0
      if let window = UIApplication.shared.keyWindow {
        self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
      }
    }) { (success) in
      <#code#>
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
      break
    case SettingsType.sort.rawValue:
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
      break
    case SettingsType.sort.rawValue:
      labelText = sortTypes[indexPath.item]
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
      return 1
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
