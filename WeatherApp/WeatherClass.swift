//
//  WeatherClass.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/12/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherClass: NSObject {
    var id: Int = 0
    var cityName:String = ""
    var date: Int = 0
    
    
    
    //main
    var temperature: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0
    
    //wind
    var windSpeed: Double = 0.0
    var windDeg: Double = 0.0
    
    //sys
    var country: String = ""
    
    //clouds
    var clouds: Int = 0
    
    
    //weather
    var weatherID: Int = 0
    var weatherMain: String = ""
    var weatherIcon: String = ""
    var weatherDesc: String = ""
    
    
    
    static let apiKey:String = "10f09520ecd91670d285f15548b94940"
    //static let baseURLForOneCountry: String = "https://api.openweathermap.org/data/2.5/onecall?"
    
    static let baseURL: String = "https://api.openweathermap.org/data/2.5/find?"
    // https://api.openweathermap.org/data/2.5/find?lat=40.7130125&lon=-74.0071296&cnt=20&appid=10f09520ecd91670d285f15548b94940
    
    
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([WeatherClass]?) -> ()) {
        
        let url = baseURL + "lat=\(location.latitude)&lon=\(location.longitude)&cnt=50&appid=\(apiKey)"
        print(url)
        
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[WeatherClass] = [] //clear the array
            
            var tempID: WeatherClass
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                        
                        //                        print(json)
                        
                        tempID =  WeatherClass.init()
                        
                        if let arrayData = json["list"]  as? [Dictionary <String,AnyObject>] {
                            
                            
                            for dailyForecasts in arrayData {
                                
                                tempID.id = dailyForecasts["id"] as! Int
                                tempID.cityName = dailyForecasts["name"] as! String
                                tempID.date = dailyForecasts["dt"] as! Int
                                
                                
                                
                                guard let dictMainData = dailyForecasts["main"] as? Dictionary <String,AnyObject> else {
                                    
                                    // print(error!.localizedDescription)
                                    
                                    return
                                    
                                }
                                
                                tempID.temperature = dictMainData["temp"] as! Double
                                tempID.tempMin = dictMainData["temp_min"] as! Double
                                tempID.tempMax = dictMainData["temp_max"] as! Double
                                tempID.humidity = dictMainData["humidity"] as! Int
                                tempID.pressure = dictMainData["pressure"] as! Int
                                
                                
                                guard let dictWindData = dailyForecasts["wind"] as? Dictionary <String,AnyObject> else {
                                    
                                    // print(error!.localizedDescription)
                                    
                                    return
                                    
                                }
                                
                                tempID.windSpeed = dictWindData["speed"] as? Double ?? 0.0
                                tempID.windDeg = dictWindData["deg"] as? Double  ?? 0.0
                                
                                guard let dictSysData = dailyForecasts["sys"] as? Dictionary <String,AnyObject> else {
                                    
                                    // print(error!.localizedDescription)
                                    
                                    return
                                    
                                }
                                
                                tempID.country = dictSysData["country"] as! String
                                
                                
                                
                                guard let dictcloudsData = dailyForecasts["clouds"] as? Dictionary <String,AnyObject> else {
                                    
                                    // print(error!.localizedDescription)
                                    
                                    return
                                    
                                }
                                
                                tempID.clouds = dictcloudsData["all"] as! Int
                                
                                // let weatherData = dailyForecasts["weather"] as?  [String,AnyObject]
                                
                                if let weatherData = dailyForecasts["weather"]  as? [Dictionary <String,AnyObject>]{
                                    
                                    for weatherDicData in weatherData {
                                        
                                        tempID.weatherID = weatherDicData["id"] as! Int
                                        tempID.weatherMain = weatherDicData["main"] as! String
                                        tempID.weatherDesc = weatherDicData["description"] as! String
                                        tempID.weatherIcon = weatherDicData["icon"] as!  String
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                        forecastArray.append(tempID)
                        
                        
                        
                        
                        
                    }
                }catch {
                    
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    
}










