//
//  FavouriteRepository.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/26.
//

import Foundation

typealias CreateLocation = (Result<Void, CoreDataError>) -> Void
typealias SavedLocationsResult = (Result<[Location], CoreDataError>) -> Void

protocol FavouriteRepositoryType {
    func createLocationItem(location: Response?, completion: @escaping (CreateLocation))
    func fetchSavedLocations(completion: @escaping (SavedLocationsResult))
}

class FavouriteRepository: FavouriteRepositoryType {
    private var locations: [Location]? = []
    
    func createLocationItem(location: Response?, completion: @escaping (CreateLocation)) {
        guard let location = location else {
            completion(.failure(.createError))
            return
        }
        
        guard let context = Constants.context else {
            completion(.failure(.createError))
            return
        }
        
        let newLocation = Location(context: context)
        newLocation.location = location.name
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(.createError))
        }
    }
    
    func fetchSavedLocations(completion: @escaping (SavedLocationsResult)) {
        do {
            self.locations = try Constants.context?.fetch(Location.fetchRequest())
            guard let savedLocations = self.locations else { return }
            completion(.success(savedLocations))
            
        } catch {
            completion(.failure(.fetchError))
        }
    }
}
