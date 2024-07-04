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
        tableView.register(SearchResultsTableViewCell.self, forCellReuseIdentifier: "SearchResultsTableViewCell")
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: 500, left: 16, bottom: 500, right: 16)
        return tableView
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = track.name
        
        if let imageUrlString = track.album?.images.first?.url,
           let imageUrl = URL(string: imageUrlString) {
            cell.imageView?.kf.setImage(with: imageUrl)
        } else {
            cell.imageView?.image = nil
        }
        cell.backgroundColor = .black
        cell.tintColor = .black
        cell.textLabel?.textColor = .white
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let inset: CGFloat = 24.0
        let customFrame = cell.frame.insetBy(dx: 0, dy: inset / 2)
        cell.frame = customFrame
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.section]
        PlayerPresenter.shared.startPlayer(from: self, track:
            .init(title: track.name ?? "", subtitle: track.album?.name, image: track.album?.images.first?.url ?? "", previewUrl: track.previewUrl, id: "")
        )
    }
}
