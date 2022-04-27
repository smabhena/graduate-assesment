//
//  FavouriteViewModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/26.
//

import Foundation

protocol FavouriteViewModelDelegate: AnyObject {
    func reloadView()
    func show(error: String)
}

class FavouriteViewModel {
    private weak var delegate: FavouriteViewModelDelegate?
    private var repository: FavouriteRepositoryType?
    private var locations: [Location]? = []
    
    init(delegate: FavouriteViewModelDelegate, repository: FavouriteRepositoryType){
        self.delegate = delegate
        self.repository = repository
    }
    
    var locationsCount: Int {
        return locations?.count ?? 0
    }
    
    var locationList: [Location]? {
        return locations
    }
    
    func location(atIndex: Int) -> Location? {
        return locations?[atIndex]
    }
    
    func allSavedLocations() {
        repository?.fetchSavedLocations(completion: { [weak self] locations in
            switch locations {
            case .success(let savedLocations):
                self?.locations = savedLocations
                DispatchQueue.main.async {
                    self?.delegate?.reloadView()
                }
            case .failure:
                self?.delegate?.show(error: "Failed to fetch locations")
            }
        })
    }
}
