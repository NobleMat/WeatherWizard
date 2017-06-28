//
//  PPlaceDetailsViewController.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 27/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import UIKit

class PPlaceDetailsViewController: UIViewController {
  
  @IBOutlet weak var backgroundView: UIViewX!
  var weatherDetails: Weather!
  let cellIdentifiersArray:[String] = ["LastUpdateCellIdentifier", "PlaceNameCellIdentifier", "WeatherTempCellIdentifier", "cell", "cell", "OtherDetailsCellIdentifier"]
  var isCelsius = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    addBackgroundDetails(weatherDetails)
    self.automaticallyAdjustsScrollViewInsets = false
    
    self.title = "Details"
  }
  
  func buildWeatherDetails(weather: Weather) -> String {
    var finalDetailsString = ""
    if let country = weather.countryDetails, let countryName = country.countryName {
      finalDetailsString += "Country: \(countryName)"
    }
    if weather.weatherFeelsLike != 0 {
      finalDetailsString += "\nFeels Like: \(weather.weatherFeelsLike)ºC"
    }
    if let weatherWind = weather.weatherWind {
      finalDetailsString += "\n\(weatherWind)"
    }
    if let humidity = weather.weatherHumidity {
      finalDetailsString += "\n\(humidity)"
    }
    if let sportDetails = weather.sportDetails, let sportName = sportDetails.sportDescription {
      finalDetailsString += "\n\nSport: \(sportName)"
    }
    
    return finalDetailsString
  }
  
  func addBackgroundDetails(_ weather: Weather) {
    if let weatherCondition = weather.weatherCondition {
      if weatherCondition.contains("Thunderstorm") || weatherCondition.contains("Light Rain Showers") || weatherCondition.contains("Rain") || weatherCondition.contains("Light Rain") {
        backgroundView.firstColor = UIColor.white
        backgroundView.secondColor = UIColor.gray
        
        let emitter = ParticleEmitter.get(with: #imageLiteral(resourceName: "Drops"))
        emitter.emitterPosition = CGPoint(x: backgroundView.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: backgroundView.frame.width, height: 2)
        UIView.animate(withDuration: 1.0, animations: {
          self.backgroundView.layer.addSublayer(emitter)
        })
        return
      }
      if weatherCondition.contains("Clear") {
        let radialGradient = RadialGradientView()
        radialGradient.firstColor = UIColor.white
        radialGradient.secondColor = UIColor.yellow
        
        backgroundView.insertSubview(radialGradient, at: 0)
        backgroundView.addConstraintsWithFormat(format: "H:|[v0]|", views: radialGradient)
        backgroundView.addConstraintsWithFormat(format: "V:|[v0]|", views: radialGradient)
        return
      }
      if weatherCondition.contains("Snow") {
        backgroundView.firstColor = UIColor.white
        backgroundView.secondColor = UIColor.gray
        
        let emitter = ParticleEmitter.get(with: #imageLiteral(resourceName: "Snowy"))
        emitter.emitterPosition = CGPoint(x: backgroundView.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: backgroundView.frame.width, height: 2)
        self.backgroundView.layer.addSublayer(emitter)
        return
      }
      if weatherCondition.contains("Partly Cloudy") || weatherCondition.contains("Mostly Cloudy") {
        backgroundView.firstColor = UIColor.white
        backgroundView.secondColor = UIColor.gray
        return
      }
      if weatherCondition.contains("Fog") || weatherCondition.contains("Mist") || weatherCondition.contains("Shallow Fog") {
        backgroundView.firstColor = UIColor.white
        backgroundView.secondColor = UIColor.gray
        
        let emitter = ParticleEmitter.get(with: #imageLiteral(resourceName: "Snowy"))
        emitter.emitterPosition = CGPoint(x: backgroundView.frame.width / 2, y: 50)
        emitter.emitterSize = CGSize(width: backgroundView.frame.width, height: 2)
        UIView.animate(withDuration: 1.0, animations: { 
          self.backgroundView.layer.addSublayer(emitter)
        })
        
        return
      }
    }
  }
  
}

//MARK: - Table View Data source
extension PPlaceDetailsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellIdentifiersArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.backgroundColor = .clear
    switch indexPath.row {
    case 0: //lastUpdatedLabel
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifiersArray[indexPath.row])
      cell.textLabel?.text = "Last Updated on \(weatherDetails.weatherLastUpdated.convertToDateTimeString())"
      cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
      cell.textLabel?.textAlignment = .center
      
      cell.backgroundColor = .clear
      return cell
      
    case 1: //Place name and temp
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifiersArray[indexPath.row])
      cell.imageView?.image = UIImage(named: weatherDetails.weatherCondition ?? "")?.withRenderingMode(.alwaysTemplate)
      cell.imageView?.tintColor = .black
      
      cell.textLabel?.text = weatherDetails.placeName
      cell.textLabel?.font = UIFont(name: "Baskerville-SemiBoldItalic", size: 30)
      cell.textLabel?.textAlignment = .center
      
      cell.detailTextLabel?.text = weatherDetails.weatherCondition
      cell.detailTextLabel?.font = UIFont(name: "Baskerville", size: 15)
      cell.detailTextLabel?.textAlignment = .center
      
      cell.backgroundColor = .clear
      
      return cell
      
    case 2: // Weather temp
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifiersArray[indexPath.row])
      if !isCelsius {
        cell.textLabel?.text = "\(weatherDetails.weatherTemperature.temperatureInFahrenheit()) ºF"
      } else {
        cell.textLabel?.text = "\(weatherDetails.weatherTemperature) ºC"
      }
      cell.textLabel?.font = UIFont(name: "SnellRoundhand", size: 40)
      cell.textLabel?.textAlignment = .center
      cell.backgroundColor = .clear
      return cell
      
    case 5: //Other details
      cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifiersArray[indexPath.row])
      cell.textLabel?.text = buildWeatherDetails(weather: weatherDetails)
      cell.textLabel?.font = UIFont(name: "Baskerville", size: 25)
      cell.textLabel?.numberOfLines = 0
      cell.backgroundColor = .clear
    default:
      return cell
    }
    return cell
  }
  
}

//MARK: - Table View delegate
extension PPlaceDetailsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 1:
      return 100
    case 5:
      return buildWeatherDetails(weather: weatherDetails).height(withConstrainedWidth: tableView.frame.width, font: UIFont(name: "Baskerville", size: 25)!)
    default:
      return 50
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 2 {
      isCelsius = !isCelsius
      tableView.reloadRows(at: [indexPath], with: .fade)
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.alpha = 0
    
    UIView.animate(withDuration: 1.0) {
      cell.alpha = 1
    }
  }
}
