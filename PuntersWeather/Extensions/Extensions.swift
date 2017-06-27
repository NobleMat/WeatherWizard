//
//  Extensions.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import UIKit

enum weatherType: String {
  case cloudy = "cloudy"
}

extension TimeInterval {
  
  /*
   Convert TimeInterval to Date String
   
   - returns: A String after converting from the interval
   */
  func convertToDateString() -> String {
    let convertedDate = Date(timeIntervalSince1970: self)
    
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "dd/MM/yyy"
    let dateString = newDateFormatter.string(from: convertedDate)
    return dateString
  }
  
  /*
   Convert TimeInterval to Date and Time String
   
   - returns: A String after converting from the interval
 */
  func convertToDateTimeString() -> String {
    let convertedDate = Date(timeIntervalSince1970: self)
    
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "dd/MM/yyy HH:mm"
    let dateString = newDateFormatter.string(from: convertedDate)
    return dateString
  }
}

extension UIColor {
  
  /**
   Init UIColor from hex value
   
   - Parameter rgbValue: hex color value
   - Parameter alpha: transparency level
   */
  convenience init(hex: String, alpha: CGFloat) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0
    
    var RGBValue: UInt64 = 0
    scanner.scanHexInt64(&RGBValue)
    
    let red = (RGBValue & 0xff0000) >> 16
    let green = (RGBValue & 0xff00) >> 8
    let blue = RGBValue & 0xff
    
    self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: alpha)
  }
  
//  convenience init(weatherCondition: String) {
//    
//  }
  
}

//MARK: - WeatherActivityIndicator
//Custom class to implement Activity Indicator
class WeatherActivityIndicator {
  
  static var container: UIView = UIView()
  static var loadingView: UIView = UIView()
  static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  /*
   Show customized activity indicator,
   actually add activity indicator to passing view
   
   - parameter onView - add activity indicator to this view
   */
  static func showActivityIndicator(_ onView: UIView) {
    container.frame = onView.frame
    container.center = onView.center
    container.backgroundColor = UIColor(hex: "0xffffff", alpha: 0.3)
    
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = onView.center
    loadingView.backgroundColor = UIColor(hex: "0x444444", alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    activityIndicator.activityIndicatorViewStyle = .whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    onView.addSubview(container)
    activityIndicator.startAnimating()
  }
  
  /**
   Hide activity indicator
   Actually remove activity indicator from its super view
   
   - parameter fromView: remove activity indicator from this view
   */
  static func hideActivityIndicator(_ fromView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
  }
  
}

//MARK: - UINavigationBar
extension UINavigationController {
  func setRightButtons(_ buttons: UIBarButtonItem...) {
    if buttons.count == 1 {
      navigationItem.rightBarButtonItem = buttons.first
    } else {
      navigationItem.rightBarButtonItems = buttons
    }
  }
  
  func setLeftBarButtons(_ buttons: UIBarButtonItem...) {
    if buttons.count == 1 {
      navigationItem.leftBarButtonItem = buttons.first
    } else {
      navigationItem.leftBarButtonItems = buttons
    }
  }
  
  func regularNavigationBar() {
    navigationBar.barTintColor = UIColor(hex: "3182D9", alpha: 1)
    navigationBar.tintColor = UIColor.white
    navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
  }
}

extension UIView {
  func addConstraintsWithFormat(format: String, views: UIView...) {
    var viewsDictionary = [String: UIView]()
    for (index, view) in views.enumerated() {
      let key = "v\(index)"
      view.translatesAutoresizingMaskIntoConstraints = false
      viewsDictionary[key] = view
    }
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
  }
}

extension Sequence where Iterator.Element: Hashable {
  func unique() -> [Iterator.Element] {
    var seen: [Iterator.Element: Bool] = [:]
    return self.filter { seen.updateValue(true, forKey: $0) == nil }
  }
}

extension Double {
  func temperatureInFahrenheit() -> Double {
    let fahrenheitTemperature = self * 9 / 5 + 32
    return fahrenheitTemperature
  }
  
  func temperatureInCelsius() -> Double {
    let celsiusTemperature = 5 / 9 * (self - 32)
    return celsiusTemperature
  }
}
