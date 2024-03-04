//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel?
    
    // MARK: - UI Elements
    
    private lazy var recommendedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(
            RecommendedMusicTableViewCell.self,
            forCellReuseIdentifier: "RecommendedMusicTableViewCell"
        )
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .black
        navigationItem.setBackBarItem()
        title = "Home"
        
        view.addSubview(recommendedTableView)
        recommendedTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupViewModel() {
        viewModel = HomeViewModel()
        viewModel?.loadRecommendedMusics(comletion: {
            self.recommendedTableView.reloadData()
        })
    }
    
    // MARK: - Actions
        
    override func didTapSettings() {
        let controller = SettingsViewController()
        controller.title = "Settings"
        controller.navigationItem.setBackBarItem()
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.backButtonTitle = " "
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfCells ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedMusicTableViewCell", for: indexPath) as! RecommendedMusicTableViewCell
        let data = viewModel?.getCellViewModel(at: indexPath)
        cell.configure(data: data)
        return cell
    }
}
