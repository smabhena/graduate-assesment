//
//  SearchViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/25.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet private weak var searchTableView: UITableView!
    
    private lazy var viewModel = SearchViewModel(repository: SearchRepository(), delegate: self)
    let searchController = UISearchController(searchResultsController: ResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a city"
        navigationItem.searchController = searchController
        setUpTableView()
    }
    
    func setUpTableView() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.rowHeight = 50
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else { return }
        print("Clicked")
        viewModel.fetchSearch(searchText)
    }
    
}

extension SearchViewController: SearchViewModelDelegate {
    func show(error: String) {
        self.displayAlert(title: "Error",
                          message: "Failed to search for this city",
                          buttonTitle: "Try again")
    }
    
    func reloadView() {
        searchTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchedCity = viewModel.searchedCity {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath)
        guard let cityName = viewModel.cityName else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = cityName
        
        return cell
    }
}

