//
//  WeatherGetter.swift
//  MapGomel
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import Foundation
 
 
// MARK: WeatherGetterDelegate
// ===========================
// WeatherGetter should be used by a class or struct, and that class or struct
// should adopt this protocol and register itself as the delegate.
// The delegate's didGetWeather method is called if the weather data was
// acquired from OpenWeatherMap.org and successfully converted from JSON into
// a Swift dictionary.
// The delegate's didNotGetWeather method is called if either:
// - The weather was not acquired from OpenWeatherMap.org, or
// - The received weather data could not be converted from JSON into a dictionary.

 
 
// MARK: WeatherGetter
// ===================
 
class WeatherGetter {
  
  private let openWeatherMapBaseURL = "https://api.weather.yandex.ru/v2/forecast?"
  private let openWeatherMapAPIKey = "16b8ddb2-0bce-4048-8df0-533ce4d89e35"
    private let apiKeyGeader = "X-Yandex-API-Key"
  
  
  // MARK: -
  

    weak var delegate: RequestDelegate?
 
    func getWeatherByCoordinates(latitude: Float, longitude: Float, name:String) {
    let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)&lat=\(latitude)&lon=\(longitude)")!
    getWeather(weatherRequestURL: weatherRequestURL, name: name)
  }
  
    private func getWeather(weatherRequestURL: NSURL, name:String){
    
    let session = URLSession.shared
    session.configuration.timeoutIntervalForRequest = 3
    
    var request = URLRequest(url: weatherRequestURL as URL)
    request.addValue(openWeatherMapAPIKey, forHTTPHeaderField: apiKeyGeader)
    let dataTask = session.dataTask(with: request) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if error != nil {
        print(error)
      }
      else {

        do {
            let weatherData = try JSONSerialization.jsonObject(
                with: data!,
                options: .mutableContainers) as! [String: AnyObject]
            if let info = weatherData["fact"],
               let facTemp = info["temp"] as? Float,
               let feelTemp = info["feels_like"] as? Float,
               let cond = info["condition"] as? String {
                let wind = info["wind_speed"] as? Float ?? 0
                let weather = Weather(factTemperature: facTemp, feelTemperature: feelTemp, condition: cond, windSpeed: wind)
                self.delegate?.setWeather(cityName: name, weather: weather)
            }
        }
        catch let jsonError as NSError {
            print(jsonError)
        }
      }
    }
    

    dataTask.resume()
  }
  
}
