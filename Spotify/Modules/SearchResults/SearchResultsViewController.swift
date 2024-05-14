//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Aneli  on 07.04.2024.
//

import UIKit

// MARK: - SearchResultsViewControllerDelegate Protocol

protocol SearchResultsViewControllerDelegate {
    func showResult(_ controller: UIViewController)
}

// MARK: - SearchResultsViewController

class SearchResultsViewController: BaseViewController {

    // MARK: - Properties
    
    private var tracks = [AudioTrack]()
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .black
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Update Method
    
    func update(with tracks: [AudioTrack]) {
        self.tracks = tracks
        tableView.reloadData()
        tableView.isHidden = tracks.isEmpty
    }
}

// MARK: - UITableViewDataSource

extension SearchResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.name
        cell.backgroundColor = .black
        cell.tintColor = .white
        cell.textLabel?.textColor = .white
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        PlayerPresenter.shared.startPlayer(from: self, track:
            .init(title: track.name ?? "", subtitle: track.album?.name, image: track.album?.images.first?.url ?? "", previewUrl: track.previewUrl, id: "")
        )
    }
}
