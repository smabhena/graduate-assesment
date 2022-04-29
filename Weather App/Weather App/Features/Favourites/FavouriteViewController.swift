//
//  FavouriteViewController.swift
//  Weather App
//
//  Created by Sinothando Mabhena on 2022/04/26.
//

import UIKit

class FavouriteViewController: UIViewController {
    @IBOutlet private var favouritesTableView: UITableView!
    
    private lazy var viewModel = FavouriteViewModel(delegate: self,
                                                    repository: FavouriteRepository())

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        title = "Favourites"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.allSavedLocations()
    }
    
    func setUpTableView() {
        self.favouritesTableView.delegate = self
        self.favouritesTableView.dataSource = self
    }
}
extension FavouriteViewController: FavouriteViewModelDelegate {
    func reloadView() {
        self.favouritesTableView.reloadData()
    }
    
    func show(error: String) {
        self.displayAlert(title: "Error",
                          message: "Failed to fetch favourite weather locations",
                          buttonTitle: "Try again")
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let location = viewModel.location(atIndex: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = location.location
        
        return cell
    }
}
