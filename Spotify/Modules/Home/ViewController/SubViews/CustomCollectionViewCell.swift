//
//  CustomCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import UIKit
import SkeletonView
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 8
        return imageView
    }()
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-Regular", size: 15),
        numberOfLines: 2,
        isSkeletonable: true
        )
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        titleLabel.text = nil
        if contentView.sk.isSkeletonActive {
            isSkeletonable = false
            contentView.isSkeletonable = false
            contentView.hideSkeleton()
        }
    }
    
    func configure(data: AlbumsData) {
        let imageUrl = URL(string: data.image ?? "")
        albumImageView.kf.setImage(with: imageUrl)
        titleLabel.text = data.title
    }
    
    // MARK: - Setup

    private func setupViews() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        [albumImageView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        albumImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.top.left.right.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
        }
    }
}
