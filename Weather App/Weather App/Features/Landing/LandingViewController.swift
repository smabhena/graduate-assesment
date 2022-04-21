//
//  LandingViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import UIKit

class LandingViewController: UIViewController {
    
    private lazy var viewModel = LandingViewModel(repository: LandingRepository(),
                                                  delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchWeather()
    }
}

extension LandingViewController: LandingViewModelDelegate {
    func show(error: String) {
        print("Error occured: \(error)")
    }
}
