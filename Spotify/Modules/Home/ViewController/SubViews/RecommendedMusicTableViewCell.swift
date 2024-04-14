//
//  RecommendedMusicTableViewCell.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit
import SkeletonView

class RecommendedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let musicImageSize: CGFloat = 48
        static let musicImageCornerRadius: CGFloat = 24
        static let textsStackViewSpacing: CGFloat = 2
        static let rightViewSize: CGFloat = 30
    }
    
    // MARK: - UI Elements
    
    private var musicImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Constants.musicImageCornerRadius
        image.contentMode = .scaleAspectFill
        image.isSkeletonable = true
        image.skeletonCornerRadius = 24
        return image
    }()

    private var textsStackView = StackFactory.createStackView(
        isSkeletonable: true
    )
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 16),
        isSkeletonable: true
    )
    
    private var subtitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 13),
        isSkeletonable: true
    )
    
    private var rightView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "icon_right")
        return image
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(data: RecommendedMusicData?) {
        guard let data = data else { return }
        
        if let imageUrlString = data.image, let imageUrl = URL(string: imageUrlString) {
            musicImage.kf.setImage(with: imageUrl)
        } else {
            musicImage.image = nil
        }
        
        titleLabel.text = data.title
        if let subtitle = data.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        contentView.backgroundColor = .black
        
        [titleLabel, subtitleLabel].forEach {
            textsStackView.addArrangedSubview($0)
        }
        
        [musicImage, textsStackView, rightView].forEach {
            contentView.addSubview($0)
        }

        musicImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
            make.size.equalTo(Constants.musicImageSize)
        }
        
        textsStackView.snp.makeConstraints { make in
            make.left.equalTo(musicImage.snp.right).offset(12)
            make.top.bottom.equalTo(musicImage)
            make.height.greaterThanOrEqualTo(35)
            make.width.lessThanOrEqualTo(250)
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.rightViewSize)
        }
    }
}
