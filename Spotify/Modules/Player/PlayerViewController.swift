//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.04.2024.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "chevron.down"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let musicTitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-BoldItalic", size: 21)
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
        imageView.image = UIImage(named: "heart")
        return imageView
    }()
    
    private let musicSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        slider.tintColor = .white
        return slider
    }()
    
    private let buttonStackView = StackFactory.createStackView(
        distribution: .equalSpacing
    )
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc
    private func didTapCloseButton() {
        dismiss(animated: true)
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
         musicImageView,
         favoriteImageView,
         musicSlider].forEach {
            view.addSubview($0)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.left.equalToSuperview().inset(24)
            make.size.equalTo(24)
        }
        
        musicTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.centerX.equalToSuperview()
            make.left.equalTo(closeButton.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        
        musicImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(300)
            make.left.right.equalToSuperview().inset(36)
        }
        
        musicTextStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(favoriteImageView.snp.left).offset(-12)
            make.bottom.equalTo(musicSlider.snp.top).offset(-36)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.size.equalTo(24)
            make.centerY.equalTo(buttonStackView)

        }
        
        musicSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(4)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-36)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
//            make.height.equalTo(62)
            make.bottom.equalToSuperview().inset(70)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
        
        forwardButton.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
        
        playPauseButton.snp.makeConstraints { make in
            make.size.equalTo(56)
        }
    }
}
