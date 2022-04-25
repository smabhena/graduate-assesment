//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import Foundation
import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak private var forecastTemp: UILabel!
    
    func updateCellContent(_ temp: Double) {
        self.forecastTemp.text = "\(String(Int(temp)))°C"
    }
}
