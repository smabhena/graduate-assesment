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
    func reloadView()
    func disableButton()
    func updateTheme()
}

class LandingViewModel {
    private var repository: LandingRepositoryType?
    private var coreDataRepository: FavouriteRepositoryType?
    private var delegate: LandingViewModelDelegate?
    private var weatherReponse: Response?
    private var forecastResponse: Forecast?
    
    init(repository: LandingRepository, coreDataRepository: FavouriteRepositoryType, delegate: LandingViewModelDelegate){
        self.repository = repository
        self.coreDataRepository = coreDataRepository
        self.delegate = delegate
    }
    
    var city: String? {
        return self.weatherReponse?.name
    }
    
    var weather: Response? {
        return self.weatherReponse
    }
    
    var weatherCondition: String? {
        return self.weatherReponse?.weather?[0].main
    }
    
    var forecast: Forecast? {
        return self.forecastResponse
    }
    
    var forecastList: [List]? {
        return self.forecastResponse?.list
    }
    
    var forecastCount: Int {
        return self.forecastResponse?.cnt ?? 0
    }
    
    var daysOfWeek: [String] {
        return Calendar.current.shortWeekdaySymbols
    }
    
    var today: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    var currentWeekFromToday: [String] {
        guard var dayIndex = daysOfWeek.firstIndex(of: self.today) else { return [] }
        
        var currentWeek: [String] = []
        let limit = 5
        var i = 0
        
        while i < limit {
            currentWeek.append(daysOfWeek[dayIndex])
            dayIndex = dayIndex.advanced(by: 1)
            if dayIndex > 6 {
                dayIndex = 0
            }
            i = i + 1
        }
        
        return currentWeek
    }
    
    func fetchWeather(_ latitude: String,_ longitude: String) {
        self.repository?.fetchWeatherResults(latitude, longitude, completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.weatherReponse = response
                self?.delegate?.loadContent()
                self?.delegate?.reloadView()
                self?.delegate?.updateTheme()
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
    
    func fetchForecast(_ latitude: String,_ longitude: String) {
        self.repository?.fetchForecastResults(latitude, longitude, completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.forecastResponse = response
                self?.delegate?.reloadView()
                self?.delegate?.updateTheme()
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
    
    func createLocation() {
        guard let weather = weatherReponse else { return }
        coreDataRepository?.createLocationItem(location: weather, completion: { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.disableButton()
            case .failure:
                self?.delegate?.show(error: "Failed to save movie")
            }
        })
    }
    
    func isLocationSaved() {
        guard let location = weatherReponse else { return }
        coreDataRepository?.isLocationSaved(location: location, completion: { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.disableButton()
            case .failure:
                self?.delegate?.show(error: "Failed to check if location is saved")
            }
        })
    }
    
    func createOfflineLocation() {
        guard let weather = weatherReponse else { return }
        repository?.createOfflineLocationItem(location: weather, completion: { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.disableButton()
            case .failure:
                print("failure")
                self?.delegate?.show(error: "Failed to save offline weather")
            }
        })
    }
    
}
