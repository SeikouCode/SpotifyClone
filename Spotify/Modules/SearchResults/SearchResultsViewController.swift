//
//  SearchResultsViewController.swift
//  Spotify
//
//  Created by Aneli  on 07.04.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate {
    func showResult(_ controller: UIViewController)
}

class SearchResultsViewController: BaseViewController {

    private var tracks = [AudioTrack]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func update(with tracks: [AudioTrack]) {
        self.tracks = tracks
        tableView.reloadData()
        tableView.isHidden = tracks.isEmpty
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        PlayerPresenter.shared.startPlayer(from: self, track:
                .init(title: track.name ?? "", subtitle: track.album?.name, image: track.album?.images.first?.url ?? "", previewUrl: track.previewUrl, id: "")
        )
    }
}
