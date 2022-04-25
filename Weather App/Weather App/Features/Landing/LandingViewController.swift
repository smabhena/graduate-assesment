//
//  LandingViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import UIKit
import CoreLocation

class LandingViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private var tempreture: UILabel!
    @IBOutlet private var weather: UILabel!
    
    private var manager: CLLocationManager = CLLocationManager()
    private lazy var viewModel = LandingViewModel(repository: LandingRepository(),
                                                  delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpManager()
    }
    
    func setUpManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        
        viewModel.fetchWeather(latitude, longtitude)
        viewModel.fetchForecast(latitude, longtitude)
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
    
    func loadForecast() {
        
    }
}
