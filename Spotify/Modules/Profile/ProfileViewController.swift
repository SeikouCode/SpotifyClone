//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

class ProfileViewController: UIViewController {

    // MARK: - Properties

    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_profile_image")
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var displayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 14)
        return label
    }()
    
    private var idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 14)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 14)
        return label
    }()
    
    private var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 14)
        return label
    }()
    
    private var productLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 14)
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        ProfileManager.shared.getCurrentUserProfile { [weak self] profile in
            DispatchQueue.main.async {
                self?.updateUI(with: profile)
            }
        }
        setupViews()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        view.backgroundColor = .black
        self.title = "Profile"
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [profileImageView,
         displayNameLabel,
         idLabel,
         emailLabel,
         countryLabel,
         productLabel
        ].forEach {
            containerView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
            make.bottom.equalTo(productLabel.snp.bottom).offset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(100)
        }
        
        displayNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
            
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(displayNameLabel)
            make.top.equalTo(displayNameLabel.snp.bottom).offset(10)
        }
            
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(displayNameLabel)
            make.top.equalTo(idLabel.snp.bottom).offset(10)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(displayNameLabel)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
        }
            
        productLabel.snp.makeConstraints { make in
            make.left.equalTo(displayNameLabel)
            make.top.equalTo(countryLabel.snp.bottom).offset(10)
        }
    }
    
    private func updateUI(with profile: ProfileModel) {
        displayNameLabel.text = profile.displayName.map { "Full Name: \($0)" }
        idLabel.text = profile.id.map { "User ID: \($0)" }
        emailLabel.text = profile.email.map { "Email Address: \($0)" }
        countryLabel.text = profile.country.map { "Country: \($0)" }
        productLabel.text = profile.product.map { "Product: \($0)" }

        if let imageURLString = profile.images.first?.url, let imageURL = URL(string: imageURLString) {
            profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "default_profile_image"))
        } else {
            profileImageView.image = UIImage(named: "default_profile_image")
        }
    }
}
