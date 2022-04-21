//
//  LandingRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/21.
//

import Foundation

typealias WeatherResponse = (Result<Response, APIError>) -> Void

protocol LandingRepositoryType: AnyObject {
    func fetchWeatherResults(method: Method, completionHandler: @escaping WeatherResponse)
}

class LandingRepository: LandingRepositoryType {
    let lat: String
    let lon: String
    let apikey: String
    let url: String
    
    init() {
        self.lat = "35"
        self.lon = "139"
        self.apikey = "ced76cc94a19715f73c16d224dbfc9d1"
        self.url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apikey)"
    }

    func fetchWeatherResults(method: Method, completionHandler: @escaping WeatherResponse) {
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
                    print(error)
                    completionHandler(Result.failure(.parsingError))
                }
            }
        }.resume()
    }
}
