//
//  LandingViewModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

protocol LandingViewModelDelegate: AnyObject {
    func show(error: String)
    func loadContent()
}

class LandingViewModel {
    private var repository: LandingRepositoryType?
    private var delegate: LandingViewModelDelegate?
    private var weatherReponse: Response?
    
    init(repository: LandingRepository, delegate: LandingViewModelDelegate){
        self.repository = repository
        self.delegate = delegate
    }
    
    var weather: Response? {
        return self.weatherReponse
    }
    
    func fetchWeather(_ latitude: String,_ longitude: String) {
        self.repository?.fetchWeatherResults(latitude, longitude, completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.weatherReponse = response
                self?.delegate?.loadContent()
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
}
