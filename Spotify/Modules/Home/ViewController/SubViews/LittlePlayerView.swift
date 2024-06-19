//
//  LittlePlayerView.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import UIKit

final class LittlePlayerView: UIView {
    
    private let musicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "play.fill")
        imageView.layer.cornerRadius = 2
        return imageView
    }()

    private var musicTextsStackView = StackFactory.createStackView(
        spacing: 2,
        distribution: .equalSpacing,
        axis: .vertical
    )
    
    private var musicTitleLabel = LabelFactory.createLabel(
        text: "Yellow",
        font: UIFont.systemFont(ofSize: 14, weight: .bold)
    )
    
    private var musicSubtitleLabel = LabelFactory.createLabel(
        text: "Coldplay",
        font: UIFont.systemFont(ofSize: 13, weight: .regular)
    )
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_favofite")
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .alizarin
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [musicTitleLabel, musicSubtitleLabel].forEach {
            musicTextsStackView.addArrangedSubview($0)
        }
        
        [musicImageView,
         musicTextsStackView,
         favoriteImageView].forEach {
            addSubview($0)
        }
        
        musicImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.left.top.bottom.equalToSuperview().inset(8)
        }
        
        musicTextsStackView.snp.makeConstraints { make in
            make.centerY.equalTo(musicImageView)
            make.left.equalTo(musicImageView.snp.right).offset(12)
        }
        
        favoriteImageView.snp.makeConstraints { make in
            make.centerY.equalTo(musicImageView)
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(24)
        }
    }
}
