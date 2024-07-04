//
//  GenreCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 11.04.2024.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "GenreCollectionViewCell"
    
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = randomColor()
        
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.isSkeletonable = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentView.backgroundColor = randomColor()
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        contentView.backgroundColor = randomColor()
    }
    
    private func randomColor() -> UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        
        repeat {
            r = CGFloat(arc4random()) / CGFloat(UInt32.max)
            g = CGFloat(arc4random()) / CGFloat(UInt32.max)
            b = CGFloat(arc4random()) / CGFloat(UInt32.max)
        } while r + g + b < 1.5
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
