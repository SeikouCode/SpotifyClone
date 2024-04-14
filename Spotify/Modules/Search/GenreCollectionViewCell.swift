//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private var colors: [UIColor] = [.systemBlue, .systemMint, .systemYellow, .systemPink, .systemBrown, .systemGray, .systemIndigo]
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont(name: "PlayfairDisplay-BoldItalic", size: 22),
        isSkeletonable: true
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .black
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        contentView.backgroundColor = colors.randomElement()
    }
}
