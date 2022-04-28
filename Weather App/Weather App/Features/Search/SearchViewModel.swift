//
//  SearchViewModel.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import Foundation

protocol SearchViewModelDelegate {
    func show(error: String)
    func reloadView()
}

class SearchViewModel {
    private var repository: SearchRepositoryType?
    private var delegate: SearchViewModelDelegate?
    private var searchResponse: Search?
    
    init(repository: SearchRepositoryType,
         delegate: SearchViewModelDelegate){
        self.repository = repository
        self.delegate = delegate
    }
    
    var searchedCity: Search? {
        return self.searchResponse
    }
    
    var cityName: String? {
        return self.searchedCity?.name
    }
    
    
    func fetchSearch(_ cityName: String) {
        self.repository?.fetchSearchResults(cityName, completionHandler: { [weak self] result in
            switch result {
            case .success(let response):
                self?.searchResponse = response
                self?.delegate?.reloadView()
            case .failure(let error):
                self?.delegate?.show(error: error.rawValue)
            }
        })
    }
}
