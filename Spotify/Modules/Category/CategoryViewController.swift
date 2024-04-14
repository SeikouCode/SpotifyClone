//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import UIKit

class CategoryViewController: BaseViewController {

    let category: Category
    private var playlists = [FeaturedPlaylists]()
    
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
        return collection
    }()
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        navigationController?.navigationBar.barTintColor = .black

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
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

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(
            data: .init(
                id: playlist.id,
                title: playlist.images?.first?.url ?? "",
                image: playlist.name
            )
        )
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlist = playlists[indexPath.row]
        let viewController = MediaDetailsViewController(playlist:
                .init(
                    id: playlist.id,
                    title: playlist.images?.first?.url ?? "",
                    image: playlist.name
                )
        )
        viewController.title = playlist.name
        viewController.navigationItem.titleView?.backgroundColor = .black
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
