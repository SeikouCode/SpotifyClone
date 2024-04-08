//
//  SearchViewController.swift
//  Spotify
//
//  Created by Aneli  on 16.02.2024.
//

import UIKit

class SearchViewController: BaseViewController {

    private lazy var searchViewController: UISearchController = {
        let searchViewController = UISearchController(searchResultsController: SearchResultsViewController())
        searchViewController.searchBar.placeholder = "What do you want to listen to?".localized
        searchViewController.searchBar.searchBarStyle = .minimal
        searchViewController.definesPresentationContext = true
        searchViewController.searchResultsUpdater = self
        return searchViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .black
        navigationItem.searchController = searchViewController
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard
            let resultsViewController = searchController.searchResultsController as?
                SearchResultsViewController,
            let text = searchController.searchBar.text,
            text.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        print("Search Text", text)
    }
}
