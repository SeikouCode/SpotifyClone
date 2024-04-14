//
//  SearchViewController.swift
//  Spotify
//
//  Created by Aneli  on 16.02.2024.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private var categories: [Category] = []
    
    private lazy var searchViewController: UISearchController = {
        let searchViewController = UISearchController(searchResultsController: SearchResultsViewController())
        searchViewController.searchBar.placeholder = "What do you want to listen to?".localized
        searchViewController.searchBar.searchBarStyle = .minimal
        searchViewController.searchBar.tintColor = .white
        searchViewController.definesPresentationContext = true
        searchViewController.searchResultsUpdater = self
        searchViewController.searchBar.delegate = self
        return searchViewController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
            
            return NSCollectionLayoutSection(group: group)
        }
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search".localized
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.searchController = searchViewController
        searchViewController.searchBar.delegate = self
        searchViewController.searchResultsUpdater = self
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        CategoryManager.shared.getCategories { [weak self]result in
            switch result {
                case .success(let categories):
                    self?.categories = categories
                    self?.collectionView.reloadData()
                case .failure: break
            }
        }
    }
}
extension SearchViewController: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            guard
                let resultsViewController = searchController.searchResultsController as?
                    SearchResultsViewController,
                let text = searchController.searchBar.text,
                !text.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }
            SearchManager.shared.search(query: text) { result in
                switch result {
                    case .success(let tracks):
                        resultsViewController.update(with: tracks)
                    case .failure(let error):
                        break
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .white
    }
}

    
extension SearchViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard
                let resultsViewController = searchViewController.searchResultsController as? SearchResultsViewController,
                let query = searchViewController.searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }
            
            SearchManager.shared.search(query: query) { [weak self] result in
                switch result {
                case .success(let tracks):
                    resultsViewController.update(with: tracks)
                case .failure(let error):
                    break
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            categories.count
    }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
        }
            let category = categories[indexPath.row]
            cell.configure(with: category.name)
            return cell
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let category = categories[indexPath.row]
            let categoryViewController = CategoryViewController(category: category)
            categoryViewController.navigationItem.largeTitleDisplayMode = .never
            categoryViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(categoryViewController, animated: true)
    }
}
