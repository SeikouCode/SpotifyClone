//
//  MediaDetailsViewController.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import UIKit
import SkeletonView

class MediaDetailsViewController: BaseViewController {
    
    var isPlaylistDetails: Bool = false
    var playlist: AlbumsData
    private var albumDetails: AlbumDetailsResponse?
    private var playlistDetails: PlaylistDetailsResponse?
    private var tracksData: [RecommendedMusicData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var tracks: [AudioTrack] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            return self.createCollectionLayout()
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.sizeToFit()
        collectionView.register(
            RecommendedCollectionViewCell.self,
            forCellWithReuseIdentifier: "RecommendedCollectionViewCell"
        )
        collectionView.register(
            PlaylistCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "PlaylistCollectionReusableView"
        )
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
        collectionView.bounces = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(playlist: AlbumsData) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        baseSetupNavigationBar()
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .black
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBarAppearance.backgroundColor = UIColor(
            red: 0.0/255.0,
            green: 128.0/255.0,
            blue: 174.0/255.0,
            alpha: 1
        )
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
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
    
    private func fetchData() {
        guard let id = playlist.id else {
            print("Playlist is not initialized")
            return
        }
        
        collectionView.showAnimatedGradientSkeleton()
        
        if isPlaylistDetails {
            AlbumsManager.shared.getPlaylistDetails(playlistID: id) { [weak self] result in
                switch result {
                case .success(let dataModel):
                    self?.tracks = dataModel.tracks.items.compactMap({ $0.track })
                    
                    self?.tracksData = dataModel.tracks.items.compactMap({ item in
                        .init(
                            title: item.track?.name ?? "",
                            subtitle: item.track?.artists.first?.name,
                            image: item.track?.album?.images.first?.url,
                            previewUrl: item.track?.previewUrl
                        )
                    })
                    self?.playlistDetails = dataModel
                    self?.collectionView.stopSkeletonAnimation()
                    self?.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
                    case .failure(_):
                    break
                }
            }
        } else {
            AlbumViewModel().getAlbumDetails(albumId: id) { [weak self] result in
                switch result {
                case .success(let dataModel):
                        self?.tracks = dataModel.tracks.items ?? []
                        
                        self?.tracksData = dataModel.tracks.items?.compactMap({ item in
                            .init(
                                title: item.name ?? "",
                                subtitle: item.artists.first?.name ?? "",
                                image: item.album?.images.first?.url ?? "",
                                previewUrl: item.previewUrl ?? ""
                            )
                        }) ?? []

                    self?.albumDetails = dataModel
                    self?.collectionView.stopSkeletonAnimation()
                    self?.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))

                case .failure(let error):
                    print("Failed to get album details:", error)
                }
            }
        }
    }
}

extension MediaDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracksData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
        cell.configure(data: tracksData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlaylistCollectionReusableView", for: indexPath) as! PlaylistCollectionReusableView
        
        if let playlistDetails = playlistDetails {
            var sum = 0
            for item in playlistDetails.tracks.items {
                if let track = item.track {
                    sum += track.durationMs ?? 0
                }
            }
//                    let durationInSeconds = Double.durationFromMilliseconds(sum)
//                    var convertDuration = durationInSeconds.formattedDuration(style: .abbreviated)
//                    let songDuration = "\(playlistDetails.tracks.items.first?.track.popularity ?? 0) likes • \(convertDuration)"
            
            header.configure(
                image: playlistDetails.images?.first?.url,
                title: playlistDetails.name,
                subtitle: playlistDetails.description,
                songDuration: "" /*songDuration*/
            )
        } else {
            if let albumDetails = self.albumDetails {
                if let items = albumDetails.tracks.items {
                    var sum = 0
                    for track in items {
                        sum += track.durationMs ?? 0
                    }
                }
                header.configure(
                    image: albumDetails.images?.first?.url,
                    title: albumDetails.name,
                    subtitle: albumDetails.description,
                    songDuration: ""
                )
            }
        }
        
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracksData[indexPath.row]
        PlayerPresenter.shared.startPlayer(from: self, track: track)
    }
}

// MARK: - SkeletonCollectionViewDataSource
extension MediaDetailsViewController: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func collectionSkeletonView(
        _ skeletonView: UICollectionView,
        cellIdentifierForItemAt indexPath: IndexPath
    ) -> SkeletonView.ReusableCellIdentifier {
        return "RecommendedCollectionViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        return "PlaylistCollectionReusableView"
    }
}

// MARK: - Private Methods
extension MediaDetailsViewController {
    private func createCollectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        ))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(64)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = .init(top: 4, leading: 0, bottom: 16, trailing: 0)
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                    heightDimension: .fractionalWidth(1)),
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .top
            )
        ]
        return section
    }
}

// MARK: - PlaylistDetailHeaderViewDelegate
extension MediaDetailsViewController: PlaylistDetailHeaderViewDelegate {
    func didTapFavorite(_ header: PlaylistCollectionReusableView) {
        print("favorite")
    }
    
    func didTapPlayAll(_ header: PlaylistCollectionReusableView) {
        print("playing all")
        PlayerPresenter.shared.startPlayer(from: self, tracks: tracksData)
    }
    
    func didTapShare(_ header: PlaylistCollectionReusableView) {
        var url: URL?
        
        if let playlistURLString = playlistDetails?.external_urls?["spotify"] {
            url = URL(string: playlistURLString)
        } else if let albumURLString = albumDetails?.external_urls?["spotify"] {
            url = URL(string: albumURLString)
        }
        
        guard let finalURL = url else {
            return
        }
        
        let viewController = UIActivityViewController(
            activityItems: ["Check out this cool song I found!", finalURL],
            applicationActivities: []
        )
        present(viewController, animated: true)
    }
}
