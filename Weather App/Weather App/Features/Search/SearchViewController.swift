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
    let searchController = UISearchController()

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
        searchTableView.rowHeight = 150
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
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        guard let cityName = viewModel.cityName else {
            return UITableViewCell()
        }
        
        guard let weather = viewModel.searchedCity?.weather?[0].main else {
            return UITableViewCell()
        }
        
        guard let temp = viewModel.searchedCity?.main?.temp else {
            return UITableViewCell()
        }
        
        cell.updateCellContent(cityName, temp, weather)
        
        return cell
    }
}


