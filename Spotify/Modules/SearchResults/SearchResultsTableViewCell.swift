//
//  SearchResultsTableViewCell.swift
//  Spotify
//
//  Created by Aneli  on 02.07.2024.
//

import UIKit
import Kingfisher
import SkeletonView
import SnapKit

final class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let musicImageSize: CGFloat = 250
        static let musicImageCornerRadius: CGFloat = 18
        static let textsStackViewSpacing: CGFloat = 2
        static let rightViewSize: CGFloat = 30
    }
    
    // MARK: - Views
    
    private var musicImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Constants.musicImageCornerRadius
        image.layer.borderColor = UIColor.black.cgColor
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isSkeletonable = true
        image.skeletonCornerRadius = 24
        return image
    }()

    private var textsStackView = StackFactory.createStackView(
        isSkeletonable: true
    )
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont.systemFont(ofSize: 16, weight: .regular),
        isSkeletonable: true
    )
    
    private var subtitleLabel = LabelFactory.createLabel(
        font: UIFont.systemFont(ofSize: 13, weight: .regular),
        isSkeletonable: true
    )
    
    private var rightView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "icon_right")
        return image
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(data: Track) {
        titleLabel.text = data.name
        musicImage.showAnimatedGradientSkeleton()
        
        if let imageUrlString = data.album?.images?.first?.url,
           let imageUrl = URL(string: imageUrlString) {
            musicImage.kf.setImage(with: imageUrl) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    self.musicImage.hideSkeleton()
                case .failure(let error):
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    self.musicImage.hideSkeleton()
                }
            }
        } else {
            musicImage.image = nil
            musicImage.hideSkeleton()
        }
    }
    
    // MARK: - Setup Views
    
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
            make.top.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(28).priority(.low)
            make.height.equalTo(Constants.musicImageSize)
        }
        
        textsStackView.snp.makeConstraints { make in
            make.left.equalTo(musicImage.snp.right).offset(12)
            make.top.bottom.equalTo(musicImage)
            make.right.lessThanOrEqualTo(rightView.snp.left).offset(-20)
            make.height.greaterThanOrEqualTo(35)
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.rightViewSize)
        }
    }
}
