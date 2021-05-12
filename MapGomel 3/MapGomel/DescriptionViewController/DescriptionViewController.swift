//
//  DescriptionViewController.swift
//  MapGomel
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit

class DescriptionViewController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var FeelTemperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var museumInfoLabel: UILabel!
    
    var cityName = ""
    var museumsInfo = ""
    var weather:Weather?
    override func viewDidLoad() {
        super.viewDidLoad()

        cityNameLabel.text = cityName
        temperatureLabel.text = "Current temperature: " + String(weather?.factTemperature ?? 0) + "°C"
        FeelTemperatureLabel.text = "Feels like: " + String (weather?.feelTemperature ?? 0) + "°C"
        conditionLabel.text = "Weather condition: " + String(weather?.condition ?? "clear")
        windLabel.text = "Wind speed: " + String(weather?.windSpeed ?? 0) + " m/sec"
        
        museumInfoLabel.text = "In this perfect city named " + cityName + " you should visit next places: " + museumsInfo
    }

}
