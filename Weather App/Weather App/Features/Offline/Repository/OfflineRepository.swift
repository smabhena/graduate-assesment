//
//  OfflineRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/28.
//

import Foundation

typealias CreateOfflineWeather = (Result<Void, CoreDataError>) -> Void
typealias FetchOfflineWeather = (Result<[Offline], CoreDataError>) -> Void

protocol OfflineRepositoryType {
    func createOfflineWeather(weather: Response?, completion: @escaping (CreateOfflineWeather))
    func fetchOfflineWeather(completion: @escaping (FetchOfflineWeather))
}

class OfflineRepository: OfflineRepositoryType {
    private var weather: [Offline]? = []
    
    func createOfflineWeather(weather: Response?, completion: @escaping (CreateOfflineWeather)) {
        guard let weather = weather else {
            completion(.failure(.createError))
            return
        }
        
        guard let context = Constants.context else {
            completion(.failure(.createError))
            return
        }
        
        guard let name = weather.name else {
            completion(.failure(.createError))
            return
        }
        
        guard let tempreture = weather.main?.temp else {
            completion(.failure(.createError))
            return
        }
        
        guard let condition = weather.weather?[0].main else {
            completion(.failure(.createError))
            return
        }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let newOfflineWeather = Offline(context: context)
        newOfflineWeather.name = name
        newOfflineWeather.weather = condition
        newOfflineWeather.time = dateFormatter.string(from: date)
        newOfflineWeather.tempreture = Int(tempreture).description
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.createError))
        }
    }
    
    func fetchOfflineWeather(completion: @escaping (FetchOfflineWeather)) {
        do {
            self.weather = try Constants.context?.fetch(Offline.fetchRequest())
            guard let offlineWeather = self.weather else { return }
            completion(.success(offlineWeather))
        } catch {
            completion(.failure(.fetchError))
        }
    }
}
