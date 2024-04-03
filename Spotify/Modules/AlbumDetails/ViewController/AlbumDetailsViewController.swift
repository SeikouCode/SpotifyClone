//
//  AlbumDetailsViewController.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import UIKit

class AlbumDetailsViewController: BaseViewController {

    var viewModel: AlbumViewModel?
    var albumId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseSetupNavigationBar()
    }
    
    private func setupViewModel() {
        viewModel = AlbumViewModel()
    }
    
    private func setupGradient() {
        let firstColor = UIColor(
            red: 0.0/255.0,
            green: 128.0/255.0,
            blue: 174.0/255.0,
            alpha: 1
        ).cgColor
        
        let secondColor = UIColor.black.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor, secondColor]
        gradient.locations = [0.0, 0.4]
        gradient.type = .axial
        gradient.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}


extension AlbumDetailsViewController {
    private func createCollectionLayout(section: Int) -> NSCollectionLayoutSection {
        switch section {
            case 0:
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
