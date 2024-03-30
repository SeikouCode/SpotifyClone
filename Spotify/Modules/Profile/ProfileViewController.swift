//
//  ProfileViewController.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
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
    
    private var displayNameLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 14)
    )
    
    private var idLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 14)
    )
    
    private var emailLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 14)
    )
    
    private var countryLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 14)
    )
    
    private var productLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 14)
    )
    
    private var scrollView = UIScrollView()
    
    private var containerView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        updateUI()
        
        ProfileManager.shared.getCurrentUserProfile { [weak self] profile in
            DispatchQueue.main.async {
                self?.updateUI(with: profile)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        
        self.title = "Profile".localized
        
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
        displayNameLabel.text = NSLocalizedString("Full_name", comment: "") + ": \(profile.displayName ?? "")"
        idLabel.text = NSLocalizedString("User_Id", comment: "") + ": \(profile.id ?? "")"
        emailLabel.text = NSLocalizedString("Email_address", comment: "") + ": \(profile.email ?? "")"
        countryLabel.text = NSLocalizedString("Country", comment: "") + ": \(profile.country ?? "")"
        productLabel.text = NSLocalizedString("Product", comment: "") + ": \(profile.product ?? "")"

        if let imageURLString = profile.images.first?.url, let imageURL = URL(string: imageURLString) {
            profileImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "default_profile_image"))
        } else {
            profileImageView.image = UIImage(named: "default_profile_image")
        }
    }
    
    // MARK: - Language Change
    
    private func didChange(language: SupportedLanguages) {
        Bundle.setLanguage(language: language.rawValue)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("language"), object: nil)
            self.updateLocalization()
        }
    }

    private func updateLocalization() {
        self.title = "Profile".localized
        self.updateUI()
    }

    private func updateUI() {
        ProfileManager.shared.getCurrentUserProfile { [weak self] profile in
            DispatchQueue.main.async {
                self?.updateUI(with: profile)
            }
        }
    }
}
