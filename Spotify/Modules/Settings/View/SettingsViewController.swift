//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.03.2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var sections = [Section]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupData() {
        sections.append(
            .init(
                title: "Profile",
                rows: [
                    .init(
                        title: "View Your Profile",
                        handler: { [weak self] in
                            DispatchQueue.main.async {
                                self?.showProfilePage()
                            }
                        })
                ]
            )
        )
        
        sections.append(
            .init(
                title: "Account",
                rows: [
                    .init(
                        title: "Sign Out",
                        handler: { [weak self] in
                            DispatchQueue.main.async {
                                self?.didTapSignOut()
                            }
                        })
                ]
            )
        )
    }
    
    private func showProfilePage() {
        let controller = ProfileViewController()
        controller.title = "Profile"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Do you really want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                let authViewController = AuthViewController()
                                window.rootViewController = UINavigationController(rootViewController: authViewController)
                                window.makeKeyAndVisible()
                            }
                        }
                    }
                } else {
                    print("Error signing out")
                }
            }
        }))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = model.title
        cell.backgroundColor = .gray
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].rows[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let modelTitle = sections[section].title
        return modelTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        if section == 0 {
            headerView.textLabel?.textColor = .white
        } else if section == 1 {
            headerView.textLabel?.textColor = .white
        }
    }
}
