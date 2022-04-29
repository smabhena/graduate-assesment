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
    var url: String?
        
    func fetchSearchResults(_ cityName: String, completionHandler: @escaping SearchResponse) {
        let url =
        "\(Constants.weatherUrl)?q=\(cityName)&appid=\(Constants.apiKey)&units=metric"
        
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
