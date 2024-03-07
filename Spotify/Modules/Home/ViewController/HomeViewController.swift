//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel?
    private var sections = [HomeSectionType]()
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.createCollectionLayout(section: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: "PlaylistCollectionViewCell")
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedCollectionViewCell")
        return collectionView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        
        sections.append(.newRelesedAlbums(datamodel: [.init(), .init(), .init()]))
        sections.append(.featuredPlaylists(datamodel: [.init(), .init(), .init()]))
        sections.append(.recommended(datamodel: [.init(), .init(), .init()]))
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationItem.setBackBarItem()
        title = "Home"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    private func createCollectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(168),
                    heightDimension: .absolute(220)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 8, leading: 16, bottom: 4, trailing: 16)
            return section
        case 1:
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(168),
                    heightDimension: .absolute(220)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
            return section
        case 2:
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(64)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.contentInsets = .init(top: 4, leading: 16, bottom: 16, trailing: 16)
            return section
        default:
            // Item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(64)
                ),
                subitem: item,
                count: 1
            )
            
            //Section
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            return section
        }
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
//        viewModel?.loadRecommendedMusics(comletion: {
//            self.recommendedTableView.reloadData()
//        })
    }
    
    // MARK: - Actions
        
    override func didTapSettings() {
        let controller = SettingsViewController()
        controller.title = "Settings"
        controller.navigationItem.setBackBarItem()
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.backButtonTitle = " "
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .newRelesedAlbums(let dataModel):
            return dataModel.count
        case .featuredPlaylists(let dataModel):
            return dataModel.count
        case .recommended(let dataModel):
            return dataModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .newRelesedAlbums(let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
//            cell.configure(with: dataModel)
            cell.backgroundColor = .systemGreen
            return cell
        case .featuredPlaylists(let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistCollectionViewCell", for: indexPath) as! PlaylistCollectionViewCell
//            cell.configure(with: dataModel)
            cell.backgroundColor = .systemPink
            return cell
        case .recommended(let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
//            cell.configure(with: dataModel)
            cell.backgroundColor = .systemBlue
            return cell
        }
    }
}
