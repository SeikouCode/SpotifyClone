//
//  PlaylistCollectionReusableView.swift
//  Spotify
//
//  Created by Aneli  on 06.04.2024.
//

import UIKit
import Kingfisher

// MARK: - Protocol for Playlist Detail Header View Actions

protocol PlaylistDetailHeaderViewDelegate: AnyObject {
    func didTapPlayAll(_ header: PlaylistCollectionReusableView)
    func didTapShare(_ header: PlaylistCollectionReusableView)
    func didTapFavorite(_ header: PlaylistCollectionReusableView)
}

// MARK: - PlaylistCollectionReusableView

final class PlaylistCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: PlaylistDetailHeaderViewDelegate?
    
    // MARK: - UI Elements
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 8
        return imageView
    }()
    
    private let titleLabel = LabelFactory.createLabel(
        font: .systemFont(ofSize: 18, weight: .bold),
        numberOfLines: 2,
        isSkeletonable: true
    )
    
    private let subtitleLabel = LabelFactory.createLabel(
        font: .systemFont(ofSize: 13, weight: .bold),
        textColor: .gray,
        numberOfLines: 2,
        isSkeletonable: true
    )
    
    private let spotifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_spotify")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 12
        return imageView
    }()
    
    private let spotifyLabel = LabelFactory.createLabel(
        text: "Spotify",
        font: .systemFont(ofSize: 13, weight: .regular),
        isSkeletonable: true
    )
    
    private let timeLabel = LabelFactory.createLabel(
        font: .systemFont(ofSize: 13, weight: .regular),
        textColor: .gray,
        isSkeletonable: true
    )
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 24
        stack.axis = .horizontal
        stack.isSkeletonable = true
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var heartAction: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_favofite"), for: .normal)
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_share"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_play"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(playAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc private func playAllButtonTapped() {
        delegate?.didTapPlayAll(self)
        print("Play")
    }
    
    @objc private func heartButtonTapped() {
        delegate?.didTapFavorite(self)
        print("Like!")
    }
    
    @objc private func shareButtonTapped() {
        delegate?.didTapShare(self)
        print("Share!")
    }
    
    // MARK: - Private Methods
    
    private func setGradientBackground() {
        let colorTop = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.black.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.9]
        gradientLayer.type = .axial
        gradientLayer.frame = self.bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupViews() {
        isSkeletonable = true
        
        [playlistImageView,
         titleLabel,
         subtitleLabel,
         spotifyImageView,
         spotifyLabel,
         timeLabel,
         buttonStackView,
         playButton].forEach {
            addSubview($0)
        }
        
        [heartAction, shareButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        playlistImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(playlistImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        spotifyImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
        
        spotifyLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(spotifyImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(spotifyImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(24)
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(56)
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(4)
        }
    }
    
    // MARK: - Configuration
    
    func configure(
        image: String?,
        title: String?,
        subtitle: String?,
        songDuration: String?
    ) {
        if let imageUrl = URL(string: image ?? "") {
            playlistImageView.kf.setImage(with: imageUrl)
        }
        titleLabel.text = title
        subtitleLabel.text = subtitle
        timeLabel.text = songDuration
    }
}
