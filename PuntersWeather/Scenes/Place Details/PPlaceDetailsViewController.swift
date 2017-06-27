//
//  PPlaceDetailsViewController.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 27/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import UIKit

class PPlaceDetailsViewController: UIViewController {
  
  @IBOutlet weak var lastUpdatedLabel: UILabel!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var weatherConditionLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var otherDetailsLabel: UILabel!
  @IBOutlet weak var weatherCondition: UIImageView!
  
  @IBOutlet weak var backgroundView: UIViewX!
  var weatherDetails: Weather!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    fillLabelsWith(weatherDetails)
    
    self.title = "Details"
  }
  
  func fillLabelsWith(_ weather: Weather) {
    lastUpdatedLabel.text = "Last Updated on \(weather.weatherLastUpdated.convertToDateTimeString())"
    placeNameLabel.text = weather.placeName
    weatherConditionLabel.text = weather.weatherCondition
    weatherCondition.image = UIImage(named: weather.weatherCondition ?? "")
    temperatureLabel.text = "\(weather.weatherTemperature)ºC"
    otherDetailsLabel.text = buildWeatherDetails(weather: weather)
    addBackgroundDetails(weather)
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
    if let sportDetails = weather.sportDetails, let sportName = sportDetails.sportDescription, let place = weather.placeName {
      finalDetailsString += "\n\nMost Liked Sport at \(place) is \(sportName)"
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
