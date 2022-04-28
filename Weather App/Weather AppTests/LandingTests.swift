//
//  LandingTests.swift
//  Weather AppTests
//
//  Created by Sinothando Mabhena on 2022/04/28.
//

import XCTest
@testable import Weather_App

class LandingTests: XCTestCase {
    private var viewModel: LandingViewModel!
    private var delegate: MockDelegate!
    private var repository: MockRepository!
    private var coreDataRepository: MockCoreDataRepository!

    override func setUp() {
        super.setUp()
        self.delegate = MockDelegate()
        self.repository = MockRepository()
        self.coreDataRepository = MockCoreDataRepository()
        self.viewModel = LandingViewModel(repository: repository, coreDataRepository: coreDataRepository,
                                     delegate: delegate)
    }
    
    func testCorrectCityName() {
        viewModel.fetchWeather()
        guard let cityName = viewModel.city else { return }
        XCTAssertEqual(cityName, "Pretoria")
    }
    
    func testCorrectWeather() {
        viewModel.fetchWeather()
        guard let weather = viewModel.weather?.name else { return }
        XCTAssertEqual(weather, "Cloudy")
    }
    
    func testCorrectWeatherCondition(){
        viewModel.fetchWeather()
        guard let weatherCondition = viewModel.weatherCondition else { return }
        XCTAssertEqual(weatherCondition, "Cloudy")
    }
    
    func testCorrectForecast() {
        viewModel.fetchForecast()
        guard let cityNameForecast = viewModel.forecast?.city?.name else { return }
        XCTAssertEqual(cityNameForecast, "Pretoria")
    }
    
    func testCorrectForecastList() {
        viewModel.fetchForecast()
        guard let forecastList = viewModel.forecastList else { return }
        XCTAssertNotNil(forecastList)
    }
    
    func testCorrectdaysOfWeek() {
       XCTAssertEqual(viewModel.daysOfWeek, ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"])
    }
    
    func testInCorrectForecastCount() {
        viewModel.fetchForecast()
        XCTAssertEqual(viewModel.forecastCount, 0)
    }
    
    
    class MockDelegate: LandingViewModelDelegate {
        var showErrorCalled = false
        var loadContentCalled = false
        var reloaddViewCalled = false
        var disableButtonCalled = false
        var updateThemeCalled = false
        var updateWeatherCalled = false
        
        func show(error: String) {
            showErrorCalled = true
        }
        
        func loadContent() {
            loadContentCalled = true
        }
        
        func reloadView() {
            reloaddViewCalled = true
        }
        
        func disableButton() {
            disableButtonCalled = true
        }
        
        func updateTheme() {
            updateThemeCalled = true
        }
        
        func updateWeather() {
            updateWeatherCalled = true
        }
    }
    
    class MockCoreDataRepository: FavouriteRepositoryType {
        var shouldFail = false
        
        func mockData() -> [Location] {
            let mockLocation = Location()
            var mockSavedLocations: [Location] = []
            
            mockSavedLocations.append(mockLocation)
            
            return mockSavedLocations
        }
        
        func createLocationItem(location: Response?, completion: @escaping (CreateLocation)) {
            if shouldFail {
                completion(.failure(.createError))
            } else {
                completion(.success(()))
            }
        }
        
        func fetchSavedLocations(completion: @escaping (SavedLocationsResult)) {
            if shouldFail {
                completion(.failure(.createError))
            } else {
                completion(.success(mockData()))
            }
        }
        
        func isLocationSaved(location: Response?, completion: @escaping (isLocationSaved)) {
            if shouldFail {
                completion(.failure(.createError))
            } else {
                completion(.success(()))
            }
        }
        
        
    }
    
    class MockRepository: LandingRepositoryType {
        var shouldFail = false
        
        let mockForecast: Forecast = Forecast(cod: "cod",
                                              message: 1,
                                              cnt: 1,
                                              list: [List(dt: 1,
                                                          main: ForecastMain(temp: 22.2,
                                                                             feelsLike: 24.2,
                                                                             tempMin: 21.1,
                                                                             tempMax: 24.4,
                                                                             pressure: 1,
                                                                             seaLevel: 1,
                                                                             grndLevel: 1,
                                                                             humidity: 1,
                                                                             tempKf: 43.3),
                                                          weather: [Weather(id: 1,
                                                                            main: "Clear",
                                                                            weatherDescription: "Clear skies",
                                                                            icon: "icon")],
                                                          clouds: Clouds(all: 1),
                                                          wind: Wind(speed: 1.2,
                                                                     deg: 1,
                                                                     gust: 12.3),
                                                          visibility: 1,
                                                          pop: 12.2,
                                                          sys: Sys(type: 1,
                                                                   id: 1,
                                                                   message: 1.1,
                                                                   country: "South Africa",
                                                                   sunrise: 1,
                                                                   sunset: 1,
                                                                   pod: "Pod"),
                                                          dtTxt: "1234")],
                                              city: City(id: 1,
                                                         name: "Pretoria",
                                                         coord: Coord(lon: 12.2,
                                                                      lat: 12.4),
                                                         country: "South Africa",
                                                         population: 1133,
                                                         timezone: 3,
                                                         sunrise: 1,
                                                         sunset: 1))
        
        let mockData: Response = Response(coord: Coord(lon: 23.4, lat: 21.2),
                                          weather: [Weather(id: 1,
                                                            main: "Cloudy",
                                                            weatherDescription: "Cloudy sky",
                                                            icon: "cld")],
                                          base: "stations",
                                          main: Main(temp: 24,
                                                     feelsLike: 26,
                                                     tempMin: 19,
                                                     tempMax: 29,
                                                     pressure: 40,
                                                     humidity: 10),
                                          visibility: 0,
                                          wind: Wind(speed: 12.2,
                                                     deg: 14,
                                                     gust: 9.3),
                                          clouds: Clouds(all: 1),
                                          dt: 1,
                                          sys: Sys(type: 1,
                                                   id: 2,
                                                   message: 2.1,
                                                   country: "South Africa",
                                                   sunrise: 2901,
                                                   sunset: 90,
                                                   pod: "pod"),
                                          timezone: 1,
                                          id: 1,
                                          name: "Pretoria",
                                          cod: 1)
        
        func fetchWeatherResults(_ latitude: String, _ longitude: String, completionHandler: @escaping WeatherResponse) {
            if shouldFail {
                completionHandler(.failure(.serverError))
            } else {
                completionHandler(.success(mockData))
            }
        }
        
        func fetchForecastResults(_ latitude: String, _ longitude: String, completionHandler: @escaping ForecastResponse) {
            if shouldFail {
                completionHandler(.failure(.serverError))
            } else {
                completionHandler(.success(mockForecast))
            }
        }
        
        func createOfflineLocationItem(location: Response?, completion: @escaping (CreateOfflineLocation)) {
            if shouldFail {
                completion(.failure(.createError))
            }
        }
        
        
    }

}
