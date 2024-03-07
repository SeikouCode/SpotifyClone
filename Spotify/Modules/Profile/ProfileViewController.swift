//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.03.2024.
//

import UIKit
import SnapKit

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
        ProfileManager.shared.getCurrentUserProfile { profile in
            DispatchQueue.main.async {
                self.updateUI(with: profile)
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
        displayNameLabel.text = "Full Name: \(profile.displayName)"
        idLabel.text = "User ID: \(profile.id)"
        countryLabel.text = "Country: \(profile.country)"
        emailLabel.text = "Email: \(profile.email)"
        productLabel.text = "Plan: \(profile.product)"
        if let imageURL = URL(string: profile.images.first?.url ?? "") {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
