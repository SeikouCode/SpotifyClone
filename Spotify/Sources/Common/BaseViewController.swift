//
//  BaseViewController.swift
//  Spotify
//
//  Created by Aneli  on 27.02.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseSetupNavigationBar()
        addLanguageObserver()
    }
    
    // MARK: - Public Methods
    
    func setupTitles() { }
    
    func baseSetupNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBarAppearance.backgroundColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    // MARK: - Private Methods
    
    private func addLanguageObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadTitles),
            name: NSNotification.Name("language"),
            object: nil
        )
    }
    
    @objc
    private func reloadTitles() {
        setupTitles()
    }
}
