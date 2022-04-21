//
//  LandingViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import UIKit

class LandingViewController: UIViewController {
    @IBOutlet private var tempreture: UILabel!
    @IBOutlet private var weather: UILabel!

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
    
    func loadContent() {
        guard let data = viewModel.weather else { return }
        guard let degree = data.main?.temp else { return }
        guard let weather = data.weather else { return }
        
        let roundedDegree = Int(degree.rounded(.toNearestOrEven))
        self.tempreture.text = "\(String(roundedDegree))°C"
        self.weather.text = weather[0].main
    }
}
