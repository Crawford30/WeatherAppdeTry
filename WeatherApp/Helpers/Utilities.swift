//
//  Utilities.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/12/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func convertFromKelvinToCelcius(tempInKelvin: Double) -> Double{
        let constant: Double = 273.15
        let tempInCelcius: Double = (tempInKelvin - constant)
        return tempInCelcius
    }
    
    
    
    static func convertUnixTimeStampToStringDate(unixTimeInterval:Int ) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMM dd, yyyy" //date format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    
}
