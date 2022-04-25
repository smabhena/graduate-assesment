//
//  SearchViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import UIKit

class SearchViewController: UIViewController {
    let searchController = UISearchController(searchResultsController: ResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }  
    }
}
