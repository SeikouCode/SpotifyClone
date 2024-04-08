//
//  PlaylistCollectionReusableView.swift
//  Spotify
//
//  Created by Aneli  on 06.04.2024.
//

import UIKit
import Kingfisher

protocol PlaylistDetailHeaderViewDelegate: AnyObject {
    func didTapPlayAll(_ header: PlaylistCollectionReusableView)
    func didTapShare(_ header: PlaylistCollectionReusableView)
}

final class PlaylistCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: PlaylistDetailHeaderViewDelegate?
    
    private var playlistImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isSkeletonable = true
        image.skeletonCornerRadius = 8
        return image
    }()
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-BoldItalic", size: 28),
        numberOfLines: 2,
        isSkeletonable: true
    )
    
    private var subtitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-Regular", size: 13),
        textColor: .gray,
        numberOfLines: 2,
        isSkeletonable: true
    )
    
    private var spotifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_spotify")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 12
        return imageView
    }()
    
    private lazy var spotifyLabel = LabelFactory.createLabel(
        text: "Spotify",
        font: UIFont(name: "PlayfairDisplay-Regular", size: 13),
        isSkeletonable: true
    )
    
    private lazy var timeLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-Regular", size: 13),
        textColor: .gray,
        isSkeletonable: true
    )
    
    private var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 24
        stack.axis = .horizontal
        stack.isSkeletonable = true
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var heartAction: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_favofite"), for: .normal)
        button.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_share"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_right"), for: .normal)
        button.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_play"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(playAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setGradientBackground()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  Buttons action
    
    @objc func playAllButtonTapped() {
        delegate?.didTapPlayAll(self)
        print("Play")
    }
    
    @objc func heartButtonTapped() {
        print("Like!")
    }
    
    @objc func shareButtonTapped() {
        delegate?.didTapShare(self)
        print("Share!")
    }
    
    @objc func detailButtonTapped() {
        print("Detail!")
    }
    
    private func setGradientBackground() {
        let colorTop = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 174.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.black.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0 , 0.9]
        gradientLayer.type = .axial
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func configure(
        image: String?,
        title: String?,
        subtitle: String?,
        songDuration: String?
    ) {
        let imageUrl = URL(string: image ?? "")
        playlistImageView.kf.setImage(with: imageUrl)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        timeLabel.text = songDuration
    }
    
    private func setupViews() {
        isSkeletonable = true
        
        [playlistImageView, titleLabel, subtitleLabel, spotifyImageView, spotifyLabel, timeLabel, buttonStackView, playButton].forEach {
            addSubview($0)
        }
        
        [heartAction, shareButton, detailButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
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
}
