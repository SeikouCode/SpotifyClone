//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import UIKit

// MARK: - CategoryViewController

class CategoryViewController: BaseViewController {
    
    // MARK: - Properties
    
    let category: Category
    private var playlists = [FeaturedPlaylists]()
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(220)
                ),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            return NSCollectionLayoutSection(group: group)
        }
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: "CustomCollectionViewCell"
        )
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .black
        return collection
    }()
    
    // MARK: - Initializers
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchCategoryPlaylists()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        title = category.name
        navigationController?.navigationBar.barTintColor = .black
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    // MARK: - Network Call
    
    private func fetchCategoryPlaylists() {
        CategoryManager.shared.getCategoryPlaylist(category: category) { [weak self] result in
            switch result {
            case .success(let playlists):
                self?.playlists = playlists
                self?.collectionView.reloadData()
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let playlist = playlists[indexPath.row]
        cell.configure(
            data: .init(
                id: playlist.id,
                title: playlist.name,
                image: playlist.images?.first?.url ?? ""
            )
        )
        cell.backgroundColor = .black
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let viewController = MediaDetailsViewController(playlist:
            .init(
                id: playlist.id,
                title: playlist.name,
                image: playlist.images?.first?.url ?? ""
            )
        )
        viewController.title = playlist.name
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
