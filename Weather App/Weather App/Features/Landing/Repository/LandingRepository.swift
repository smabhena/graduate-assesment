//
//  LandingRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

typealias WeatherResponse = (Result<Response, APIError>) -> Void
typealias ForecastResponse = (Result<Forecast, APIError>) -> Void

protocol LandingRepositoryType: AnyObject {
    func fetchWeatherResults(_ latitude: String,_ longitude: String, completionHandler: @escaping WeatherResponse)
    func fetchForecastResults(_ latitude: String,_ longitude: String, completionHandler: @escaping ForecastResponse)
}

class LandingRepository: LandingRepositoryType {
    var url: String?

    func fetchWeatherResults(_ latitude: String,_ longitude: String, completionHandler: @escaping WeatherResponse) {
        
        let url = "\(Constants.weatherUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apiKey)&units=metric"
 
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
        "\(Constants.forecastUrl)?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.apiKey)&cnt=5&units=metric"
        
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
}
