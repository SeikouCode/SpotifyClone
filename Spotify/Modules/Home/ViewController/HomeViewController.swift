//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit
import SkeletonView

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel?
    
    // MARK: - UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            self.createCollectionLayout(section: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: "RecommendedCollectionViewCell")
        collectionView.register(
            HeaderView.self ,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "HeaderView")
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        setupNavigationBar()
    }
    
    override func setupTitles() {
        title = "Home".localized
        viewModel?.setupSectionTitles()
        collectionView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationItem.setBackBarItem()
        title = "Home".localized
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
        
        collectionView.showAnimatedGradientSkeleton()
        viewModel?.didLoad(completion: { [weak self] in
            self?.collectionView.stopSkeletonAnimation()
            self?.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        })
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
    }
    
    // MARK: - Actions
    
    @objc private func didTapSettings() {
        let controller = SettingsViewController()
        controller.title = "Settings".localized
        controller.navigationItem.setBackBarItem()
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.backButtonTitle = " "
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = viewModel?.getSectionViewModel(at: section)
        switch type {
        case .newReleasedAlbums(_, let dataModel):
            return dataModel.count
        case .featuredPlaylists(_, let dataModel):
            return dataModel.count
        case .recommended(_, let dataModel):
            return dataModel.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = viewModel?.getSectionViewModel(at: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch type {
        case .newReleasedAlbums(_, let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
            cell.configure(data: dataModel[indexPath.row])
            return cell
                
        case .featuredPlaylists(_, let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
            cell.configure(data: dataModel[indexPath.row])
            return cell
                
        case .recommended(_, let dataModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
            cell.configure(data: dataModel[indexPath.row])
            return cell
                
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        let type = viewModel?.getSectionViewModel(at: indexPath.section)
        
        switch type {
        case .newReleasedAlbums(let title, _):
            header.configure(text: title)
        case .featuredPlaylists(let title, _):
            header.configure(text: title)
        case .recommended(let title, _):
            header.configure(text: title)
        default:
            break
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let type = viewModel?.getSectionViewModel(at: indexPath.section)
        switch type {
            case .newReleasedAlbums(_, let dataModel):
                let album = dataModel[indexPath.row]
                let viewController = AlbumDetailsViewController()
                viewController.navigationItem.largeTitleDisplayMode = .never
                viewController.hidesBottomBarWhenPushed = true
                viewController.albumId = album.id
                viewController.title = album.title
                self.navigationController?.pushViewController(viewController, animated: true)
                
            case .featuredPlaylists(_, let dataModel):
                let playlist = dataModel[indexPath.row]
                let viewController = PlaylistDetailsViewController()
                viewController.navigationItem.largeTitleDisplayMode = .never
                viewController.hidesBottomBarWhenPushed = true
                viewController.playlistId = playlist.id
                viewController.title = playlist.title
                self.navigationController?.pushViewController(viewController, animated: true)
                
            case .recommended(_, let dataModel):
                let playerViewController = PlayerViewController()
                playerViewController.modalPresentationStyle = .overFullScreen
                present(playerViewController, animated: true)
                
        default:
                break
        }
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension HomeViewController: SkeletonCollectionViewDataSource {
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = viewModel?.getSectionViewModel(at: section)
        
        switch type {
        case .newReleasedAlbums:
            return 3
        case .featuredPlaylists:
            return 3
        case .recommended:
            return 4
        default:
            return 1
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        let type = viewModel?.getSectionViewModel(at: indexPath.section)
        
        switch type {
        case .newReleasedAlbums:
            return "CustomCollectionViewCell"
        case .featuredPlaylists:
            return "CustomCollectionViewCell"
        case .recommended:
            return "RecommendedCollectionViewCell"
        default:
            return ""
        }
    }
}

// MARK: - СreateCollectionLayout

extension HomeViewController {
    private func createCollectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(168),
                    heightDimension: .absolute(220)
                ),
                subitem: item,
                count: 1
            )
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = .init(top: 8, leading: 16, bottom: 4, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(60)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .top
                    )
                ]
                return section
                    
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .absolute(168),
                        heightDimension: .absolute(220)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: horizontalGroup)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(60)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .top
                    )
                ]
                return section
                    
            case 2:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(64)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: verticalGroup)
                section.contentInsets = .init(top: 4, leading: 16, bottom: 16, trailing: 16)
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .estimated(60)),
                          elementKind: UICollectionView.elementKindSectionHeader,
                          alignment: .top
                    )
                ]
                return section
                    
            default:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
                
                let verticalGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(64)
                    ),
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: verticalGroup)
                return section
            }
        }
    }
