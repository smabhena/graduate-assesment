//
//  LandingRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

typealias WeatherResponse = (Result<Response, APIError>) -> Void
typealias ForecastResponse = (Result<Forecast, APIError>) -> Void
typealias CreateOfflineLocation = (Result<Void, CoreDataError>) -> Void

protocol LandingRepositoryType: AnyObject {
    func fetchWeatherResults(_ latitude: String,_ longitude: String, completionHandler: @escaping WeatherResponse)
    func fetchForecastResults(_ latitude: String,_ longitude: String, completionHandler: @escaping ForecastResponse)
    func createOfflineLocationItem(location: Response?, completion: @escaping (CreateOfflineLocation))
}

class LandingRepository: LandingRepositoryType {
    let apikey: String
    var url: String?
    
    init() {
        self.apikey = "ced76cc94a19715f73c16d224dbfc9d1"
    }

    func fetchWeatherResults(_ latitude: String,_ longitude: String, completionHandler: @escaping WeatherResponse) {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apikey)&units=metric"
 
        guard let request = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.serverError))
                }
                return
            }
            
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.serverError))
                    }
                    return
                }
                let object = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(Result.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(.parsingError))
                }
            }
        }.resume()
    }
    
    func fetchForecastResults(_ latitude: String,_ longitude: String, completionHandler: @escaping ForecastResponse) {
        let url =
            "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(self.apikey)&cnt=5&units=metric"
        
        guard let request = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.serverError))
                }
                return
            }
            
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.serverError))
                    }
                    return
                }
                let object = try JSONDecoder().decode(Forecast.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(Result.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(Result.failure(.parsingError))
                }
            }
        }.resume()
    }
    
    func createOfflineLocationItem(location: Response?, completion: @escaping (CreateOfflineLocation)) {
        guard let location = location else {
            completion(.failure(.createError))
            return
        }
        
        guard let context = Constants.context else {
            completion(.failure(.createError))
            return
        }
        
        let newOfflineLocation = Offline(context: context)
        newOfflineLocation.name = location.name
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.createError))
        }
    }
}
