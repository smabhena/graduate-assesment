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
    func showOffline(response: [Offline])
}

class LandingViewModel: NSObject, CLLocationManagerDelegate {
    private lazy var manager = CLLocationManager()
    private var repository: LandingRepositoryType?
    private var coreDataRepository: FavouriteRepositoryType?
    private var offlineRepository: OfflineRepositoryType?
    private weak var delegate: LandingViewModelDelegate?
    private var weatherReponse: Response?
    private var forecastResponse: Forecast?
    private var location: CLLocation?
    private var latitude: String?
    private var longitude: String?
    private var offline = false
    
    init(repository: LandingRepositoryType,
         coreDataRepository: FavouriteRepositoryType,
         offlineRepository: OfflineRepositoryType,
         delegate: LandingViewModelDelegate) {
        super.init()
        self.repository = repository
        self.coreDataRepository = coreDataRepository
        self.offlineRepository = offlineRepository
        self.delegate = delegate
        offline = NetworkMonitor.shared.isConnected
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
        var day = 0
        
        while day < limit {
            currentWeek.append(daysOfWeek[dayIndex])
            dayIndex = dayIndex.advanced(by: 1)
            if dayIndex > 6 {
                dayIndex = 0
            }
            day = day + 1
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
        if NetworkMonitor.shared.isConnected {
            self.delegate?.updateWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
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
                self?.saveForOfflineState()
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
    
    func saveForOfflineState() {
        offlineRepository?.createOfflineWeather(weather: weatherReponse, completion: { [weak self] result in
            switch result {
            case .success(_):
                print("saved")
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
    
    func fetchLastSavedWeather() {
        offlineRepository?.fetchOfflineWeather(completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.delegate?.showOffline(response: response)
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
}
