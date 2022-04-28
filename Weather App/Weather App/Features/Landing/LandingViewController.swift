//
//  LandingViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import UIKit
import CoreLocation

class LandingViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var tempreture: UILabel!
    @IBOutlet private weak var minTempreture: UILabel!
    @IBOutlet private weak var maxTempreture: UILabel!
    @IBOutlet private weak var currentTempreture: UILabel!
    @IBOutlet private weak var weather: UILabel!
    @IBOutlet private weak var forecastTableView: UITableView!
    @IBOutlet private weak var currentWeatherView: UIView!
    @IBOutlet private weak var themeSwitch: UISwitch!
    @IBOutlet private weak var detailedTempretureView: UIView!
    @IBOutlet private weak var saveButton: UIButton!
    
    
    private var themeColor: String?
    private var theme: String?
    private var weatherCondition: String?
    private var manager: CLLocationManager = CLLocationManager()
    private lazy var viewModel = LandingViewModel(repository: LandingRepository(),
                                                  coreDataRepository: FavouriteRepository(),
                                                  delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        themeColor = "SeaBlue"
        theme = "Sea"
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.isLocationSaved()
    }
    
    
    @IBAction func saveButtonTapped() {
        viewModel.createLocation()
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch) {
        guard let condition = viewModel.weatherCondition else { return }
        if sender.isOn {
            changeTheme("Forest", condition)
        } else {
            changeTheme("Sea", condition)
        }
        
        forecastTableView.reloadData()
    }
    
    func changeTheme(_ theme: String,_ condition: String) {
        if theme == "Forest"{
            if condition == "Clouds" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_cloudy.png")!)
                self.view.backgroundColor = UIColor(named: "Cloudy")
                forecastTableView.backgroundColor = UIColor(named: "Cloudy")
                detailedTempretureView.backgroundColor = UIColor(named: "Cloudy")
                self.themeColor = condition
                self.theme = theme
            } else if condition == "Sunny" || condition == "Clear" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_sunny.png")!)
                self.view.backgroundColor = UIColor(named: "Sunny")
                forecastTableView.backgroundColor = UIColor(named: "Sunny")
                detailedTempretureView.backgroundColor = UIColor(named: "Sunny")
                self.themeColor = condition
                self.theme = theme
            } else if condition == "Rain" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_rainy.png")!)
                self.view.backgroundColor = UIColor(named: "Rainy")
                forecastTableView.backgroundColor = UIColor(named: "Rainy")
                detailedTempretureView.backgroundColor = UIColor(named: "Rainy")
                self.themeColor = condition
                self.theme = theme
            }
            
        } else if theme == "Sea" {
            if condition == "Clouds" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "sea_cloudy.png")!)
                self.view.backgroundColor = UIColor(named: "Cloudy")
                forecastTableView.backgroundColor = UIColor(named: "Cloudy")
                detailedTempretureView.backgroundColor = UIColor(named: "Cloudy")
                self.themeColor = condition
                self.theme = theme
            } else if condition == "Sunny" || condition == "Clear" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "sea_sunny.png")!)
                self.view.backgroundColor = UIColor(named: "SeaBlue")
                forecastTableView.backgroundColor = UIColor(named: "SeaBlue")
                detailedTempretureView.backgroundColor = UIColor(named: "SeaBlue")
                self.themeColor = "SeaBlue"
                self.theme = theme
            } else if condition == "Rain" {
                currentWeatherView.backgroundColor = UIColor(patternImage: UIImage(named: "sea_rainy.png")!)
                self.view.backgroundColor = UIColor(named: "Rainy")
                forecastTableView.backgroundColor = UIColor(named: "Rainy")
                detailedTempretureView.backgroundColor = UIColor(named: "Rainy")
                self.themeColor = condition
                self.theme = theme
            }
        }
    }
    
    func setUpTableView() {
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.rowHeight = 50
    }
    
    func setUpManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func setWeatherIcon(weather: String) -> UIImage {
        var weatherIcon: UIImage!
        let weatherCondition = WeatherCondition.init(rawValue: weather)
        
        switch weatherCondition {
        case .sunny:
            weatherIcon = UIImage(named: "ClearIcon")
        case .clouds:
            weatherIcon = UIImage(named: "PartlySunnyIcon")
        case .rain:
            weatherIcon = UIImage(named: "RainIcon")
        case .clear:
            weatherIcon = UIImage(named: "ClearIcon")
        case .none:
            weatherIcon = UIImage(named: "ClearIcon")
        }
        
        return weatherIcon
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latitude = String(location.coordinate.latitude)
        let longtitude = String(location.coordinate.longitude)
        
        viewModel.fetchWeather(latitude, longtitude)
        viewModel.fetchForecast(latitude, longtitude)
        viewModel.isLocationSaved()
        viewModel.createOfflineLocation()
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
        
        guard let data = viewModel.weather else {
            return UITableViewCell()
            
        }
        
        guard let weatherCondition = data.weather?[0].main else {
            return UITableViewCell()
            
        }
        
        guard let themeColor = self.themeColor else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(named: themeColor)
        
        
        let image = setWeatherIcon(weather: weatherCondition.lowercased())
        
        cell.updateCellContent(temp[indexPath.row].main?.temp ?? 0.0, viewModel.currentWeekFromToday[indexPath.row], image)
        
        return cell
    }
}

extension LandingViewController: LandingViewModelDelegate {
    func show(error: String) {
        self.displayAlert(title: "Failed to fetch weather",
                          message: error,
                          buttonTitle: "Ok")
    }
    
    func loadContent() {
        guard let data = viewModel.weather else { return }
        guard let degree = data.main?.temp else { return }
        guard let minDegree = data.main?.tempMin else { return }
        guard let maxDegree = data.main?.tempMax else { return }
        guard let weather = data.weather else { return }
        
        let roundedDegree = Int(degree.rounded(.toNearestOrEven))
        let roundedMinDegree = Int(minDegree.rounded(.toNearestOrEven))
        let roundedMaxDegree = Int(maxDegree.rounded(.toNearestOrEven))
        
        self.tempreture.text = "\(String(roundedDegree))°C"
        self.weather.text = weather[0].main
        self.city.text = viewModel.city
        self.currentTempreture.text = "\(String(roundedDegree))°C"
        self.minTempreture.text = "\(String(roundedMinDegree))°C"
        self.maxTempreture.text = "\(String(roundedMaxDegree))°C"
    }
    
    func reloadView() {
        forecastTableView.reloadData()
    }
    
    func disableButton() {
        self.saveButton.disableButton("Saved")
    }
    
    func updateTheme(){
        guard let theme = self.theme else { return }
        guard let condition = viewModel.weatherCondition else { return }
        
        self.changeTheme(theme, condition)
    }
}
