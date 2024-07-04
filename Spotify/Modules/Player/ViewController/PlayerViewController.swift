//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.04.2024.
//

import UIKit
import AVFoundation
import Kingfisher

// MARK: - Protocols

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapBackward()
    func didTapForward()
    func didTapPlayAndPause()
    func didTapFavorite()
}

// MARK: - PlayerViewController

class PlayerViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var delegate: PlayerViewControllerDelegate?
    weak var dataSource: PlayerDataSource?
    
    private var tracks: [RecommendedMusicData] = []
    private var currentTrackIndex: Int = 0
    private var player: AVPlayer?
    
    // MARK: - Initializers
    
    init(tracks: [RecommendedMusicData]) {
        self.tracks = tracks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Elements
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "chevron.down", withConfiguration: config)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = image
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let musicTitleLabel = LabelFactory.createLabel(
        font: UIFont.systemFont(ofSize: 14, weight: .bold),
        textAlignment: .center
    )
    
    private let musicTextStackView = StackFactory.createStackView(
        spacing: 2,
        distribution: .equalSpacing,
        axis: .vertical
    )
    
    private let musicImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let musicSubtitleLabel = LabelFactory.createLabel(
        font: UIFont.systemFont(ofSize: 13, weight: .regular)
    )
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 20)
        imageView.image = UIImage(systemName: "heart", withConfiguration: config)
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .white
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFavorite)))
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
        button.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 45)
        let image = UIImage(systemName: "pause.circle.fill", withConfiguration: config)
        
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = image
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlayAndPause), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
    }
    
    // MARK: - Configuration
    
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

    // MARK: - Actions
    
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
    
    @objc private func didTapFavorite() {
        delegate?.didTapFavorite()
    }
    
    @objc
    private func didTapPlayAndPause() {
        if let player = self.player {
            if player.timeControlStatus == .playing {
                player.pause()
                updatePlayPauseButtonImage(isPlaying: false)
            } else if player.timeControlStatus == .paused {
                player.play()
                updatePlayPauseButtonImage(isPlaying: true)
            }
        }
        delegate?.didTapPlayAndPause()
    }
    
    private func updatePlayPauseButtonImage(isPlaying: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 45)
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.configuration?.image = UIImage(systemName: imageName, withConfiguration: config)
    }
    
    // MARK: - Setup Views
    
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
        
        setupConstraints()
    }
    
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
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
