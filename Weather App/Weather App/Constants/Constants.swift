//
//  Constants.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/27.
//

import Foundation
import UIKit

struct Constants {
    static let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    static let apiKey = "ced76cc94a19715f73c16d224dbfc9d1"
    static let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    static let forecastUrl = "https://api.openweathermap.org/data/2.5/forecast"
}
