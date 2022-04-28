//
//  LandingViewModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation
import CoreLocation

protocol LandingViewModelDelegate: AnyObject {
    func show(error: String)
    func loadContent()
    func reloadView()
    func disableButton()
    func updateTheme()
    func updateWeather()
}

class LandingViewModel: NSObject, CLLocationManagerDelegate {
    private lazy var manager = CLLocationManager()
    private var repository: LandingRepositoryType?
    private var coreDataRepository: FavouriteRepositoryType?
    private var delegate: LandingViewModelDelegate?
    private var weatherReponse: Response?
    private var forecastResponse: Forecast?
    private var location: CLLocation?
    private var latitude: String?
    private var longitude: String?
    
    init(repository: LandingRepository, coreDataRepository: FavouriteRepositoryType, delegate: LandingViewModelDelegate){
        super.init()
        self.repository = repository
        self.coreDataRepository = coreDataRepository
        self.delegate = delegate
        setUpManager()
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
    
    func setUpManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
        self.delegate?.updateWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func fetchWeather() {
        guard let latitude = latitude else { return }
        guard let longitude = longitude else { return }
        
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
    
    func fetchForecast() {
        guard let latitude = latitude else { return }
        guard let longitude = longitude else { return }
        
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
