//
//  UIButtonExtension.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/27.
//
import Foundation
import UIKit

extension UIButton {
    func disableButton(_ disabaledTextLabel: String) {
        self.isEnabled = false
        self.setTitle(disabaledTextLabel, for: .disabled)
        self.setTitle("Saved", for: .disabled)
    }
}
