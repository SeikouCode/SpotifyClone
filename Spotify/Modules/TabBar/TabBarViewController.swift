//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Aneli  on 16.02.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
// MARK: - SetupTabBar
    
    private func setupTabBar() {
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        let searchViewController = UINavigationController(rootViewController:  SearchViewController())
        let libraryViewController = UINavigationController(rootViewController: LibraryViewController())
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 1)
        
        searchViewController.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1)
        
        libraryViewController.tabBarItem = UITabBarItem(
            title: "Your library",
            image: UIImage(named: "library"),
            tag: 1)
        
        let viewControllers: [UINavigationController] = [homeViewController, searchViewController, libraryViewController]
        
        viewControllers.forEach {
            $0.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers(viewControllers, animated: false)
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .black
    }
}
