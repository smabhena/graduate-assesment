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
    @IBOutlet private weak var forecastTableView: UITableView!
    @IBOutlet private weak var temp: UILabel!
    
    private var manager: CLLocationManager = CLLocationManager()
    private lazy var viewModel = LandingViewModel(repository: LandingRepository(),
                                                  delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpManager()
    }
    
    func setUpTableView() {
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
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

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = forecastTableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        
        guard let temp = viewModel.forecastList else {
            return UITableViewCell()
        }
        
        cell.updateCellContent(temp[indexPath.row].main?.temp ?? 0.0)
        
        return cell
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
    
    func reloadView() {
        forecastTableView.reloadData()
    }
}
