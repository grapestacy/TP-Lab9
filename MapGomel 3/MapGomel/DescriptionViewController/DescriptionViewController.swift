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
    
    var cityName = ""
    var weather:Weather?
    override func viewDidLoad() {
        super.viewDidLoad()

        cityNameLabel.text = cityName
        temperatureLabel.text = String(weather?.factTemperature ?? 0)
        FeelTemperatureLabel.text = String (weather?.feelTemperature ?? 0)
        conditionLabel.text = weather?.condition
        windLabel.text = String(weather?.windSpeed ?? 0)
        
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
