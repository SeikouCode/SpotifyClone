//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.04.2024.
//

import UIKit
import AVFoundation
import Kingfisher

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapBackward()
    func didTapForward()
    func didTapPlayAndPause()
}

class PlayerViewController: UIViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    weak var dataSource: PlayerDataSource?
    
    private var tracks: [RecommendedMusicData] = []
    private var currentTrackIndex: Int = 0
    
    init(tracks: [RecommendedMusicData]) {
        self.tracks = tracks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let musicTitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-BoldItalic", size: 14),
        textAlignment: .center
    )
    
    private let musicTextStackView = StackFactory.createStackView(
        spacing: 2,
        distribution: .equalSpacing,
        axis: .vertical
    )
    
    private let musicImageView: UIImageView = {
        let musicImageView = UIImageView()
        return musicImageView
    }()
    
    private let musicSubtitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-BoldItalic", size: 13)
    )
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_favofite")
        return imageView
    }()
    
    private let musicSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        slider.tintColor = .white
        return slider
    }()
    
    private let buttonStackView = StackFactory.createStackView(
        spacing: 0,
        distribution: .equalSpacing,
        alignment: .center, 
        axis: .horizontal
    )
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "backward.circle", withConfiguration: config)
        
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = image
        button.tintColor = .white
        button.addTarget(PlayerViewController.self, action: #selector(didTapBackward), for: .touchUpInside)
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "forward.circle", withConfiguration: config)
        
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = image
        button.tintColor = .white
        button.addTarget(PlayerViewController.self, action: #selector(didTapForward), for: .touchUpInside)
        return button
    }()

    var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 45)
        let image = UIImage(systemName: "pause.circle.fill", withConfiguration: config)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = image
        button.tintColor = .white
        button.addTarget(PlayerViewController.self, action: #selector(didTapPlayAndPause), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
    }
    
    func configure() {
        guard tracks.indices.contains(currentTrackIndex) else { return }
        
        let track = tracks[currentTrackIndex]
        musicTitleLabel.text = track.title
        musicSubtitleLabel.text = track.subtitle
        
        if let imageUrlString = track.image,
           let imageUrl = URL(string: imageUrlString) {
            musicImageView.kf.setImage(with: imageUrl) { result in
                switch result {
                case .success(let value):
                    print("Image downloaded successfully:", value.image)
                case .failure(let error):
                    print("Error downloading image:", error)
                }
            }
        } else {
            print("Image URL is nil or invalid")
        }
    }

    @objc
    private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapForward() {
        delegate?.didTapForward()
    }
    
    @objc
    private func didTapBackward() {
        delegate?.didTapBackward()
    }
    
    @objc
    private func didTapPlayAndPause() {
        delegate?.didTapPlayAndPause()
    }
    
    private func setupViews() {
        view.backgroundColor = .black

        [musicTitleLabel, musicSubtitleLabel].forEach {
            musicTextStackView.addArrangedSubview($0)
        }

        [backButton,
         playPauseButton,
         forwardButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }

        [closeButton,
         musicTitleLabel,
         musicImageView,
         musicTextStackView,
         favoriteImageView,
         musicSlider,
         buttonStackView
        ].forEach {
            view.addSubview($0)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.left.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.left.equalTo(closeButton.snp.right).offset(14)
            make.right.equalToSuperview().inset(24)
        }
        
        musicImageView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.left.right.equalToSuperview().inset(36)
            make.bottom.equalTo(musicTextStackView.snp.top).offset(-100)
        }
        
        musicTextStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(favoriteImageView.snp.left).offset(-12)
            make.bottom.equalTo(musicSlider.snp.top).offset(-36)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(24)
            make.centerY.equalTo(musicTextStackView)
        }
        
        musicSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(4)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-36)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(70)
        }
    }
}
