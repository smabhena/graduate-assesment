//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import Foundation
import UIKit

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet private weak var forecastTemp: UILabel!
    @IBOutlet private weak var day: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    func updateCellContent(_ temp: Double, _ day: String, _ icon: UIImage) {
        self.day.text = day
        self.forecastTemp.text = "\(String(Int(temp)))°C"
        self.icon.image = icon
    }
}
