//
//  SearchTableViewCell.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/26.
//

import Foundation
import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet private var name: UILabel!
    @IBOutlet private var temp: UILabel!
    
    func updateCellContent(_ name: String,_ temp: Double) {
        self.name.text = name
//        self.temp.text = "\(String(Int(temp)))°C"

    }
}
