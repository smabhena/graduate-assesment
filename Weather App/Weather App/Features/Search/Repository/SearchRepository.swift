//
//  SearchRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import Foundation

typealias SearchResponse = (Result<Search, APIError>) -> Void

protocol SearchRepositoryType: AnyObject {
    func fetchSearchResults(_ cityName: String, completionHandler: @escaping SearchResponse)
}

class SearchRepository: SearchRepositoryType {
    let apikey: String
    var url: String?
    
    init() {
        self.apikey = "ced76cc94a19715f73c16d224dbfc9d1"
    }
    
    func fetchSearchResults(_ cityName: String, completionHandler: @escaping SearchResponse) {
        let url =
        "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apikey)&units=metric"
        
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
                let object = try JSONDecoder().decode(Search.self, from: data)
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
