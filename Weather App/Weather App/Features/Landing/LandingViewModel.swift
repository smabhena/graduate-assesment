//
//  LandingViewModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

protocol LandingViewModelDelegate: AnyObject {
    func show(error: String)
}

class LandingViewModel {
    private var repository: LandingRepositoryType?
    private var delegate: LandingViewModelDelegate?
    private var weatherReponse: Response?
    
    init(repository: LandingRepository, delegate: LandingViewModelDelegate){
        self.repository = repository
        self.delegate = delegate
    }
    
    func fetchWeather() {
        self.repository?.fetchWeatherResults(method: .GET, completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.weatherReponse = response
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
}
