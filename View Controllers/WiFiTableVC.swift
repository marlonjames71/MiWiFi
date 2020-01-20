//
//  WiFiTableVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class WiFiTableVC: UIViewController {

	// MARK: - Properties & Outlets
	let wifiTableView = UITableView(frame: .zero, style: .plain)
	let addWiFiButton = MiWiFiButton(backgroundColor: .miTintColor,
									 tintColor: .miTintColor,
									 textColor: .white,
									 title: "Add WiFi",
									 image: UIImage(systemName: "plus.circle"))

	// Layer for selected cell background
	let layer = CAGradientLayer()


	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground


		configureTabBar()
		configureNavController()
		configureListTableView()
		configureAddWIFIButton()
		configureGradientLayer()
    }

	private func configureTabBar() {
		if let appearance = tabBarController?.tabBar.standardAppearance.copy() {
			appearance.backgroundImage = UIImage()
			appearance.shadowImage = UIImage()
			appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
			appearance.shadowColor = .clear
		}
	}

	private func configureNavController() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTintColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTintColor,
																   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]
		
		let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped(_:)))
		navigationItem.rightBarButtonItem = optionsButton
	}

	private func configureListTableView() {
		view.addSubview(wifiTableView)
		wifiTableView.translatesAutoresizingMaskIntoConstraints = false
		wifiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WifiCell")
		NSLayoutConstraint.activate([
			wifiTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			wifiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			wifiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			wifiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
		])
		wifiTableView.tableFooterView = UIView()
		wifiTableView.dataSource = self
		wifiTableView.delegate = self
		wifiTableView.rowHeight = 60
	}

	private func configureAddWIFIButton() {
		view.addSubview(addWiFiButton)

		NSLayoutConstraint.activate([
			addWiFiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			addWiFiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			addWiFiButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			addWiFiButton.heightAnchor.constraint(equalToConstant: 40)
		])
		addWiFiButton.addTarget(self, action: #selector(addWifiButtonTapped), for: .touchUpInside)
	}

	private func configureGradientLayer() {
		let blue = UIColor.systemBlue.withAlphaComponent(0.3)
		let clear = UIColor.clear

		layer.colors =  [blue.cgColor, clear.cgColor]
	}

	// MARK: - Actions

	@objc private func optionsButtonTapped(_ sender: UIBarButtonItem) {
		Alerts.showOptionsActionSheet(vc: self)
	}

	@objc private func addWifiButtonTapped() {
		let addWifiVC = AddWIFIVC()
		addWifiVC.modalPresentationStyle = .overFullScreen
		present(addWifiVC, animated: true)
	}
}

extension WiFiTableVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		5
	}

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let detailAction = UIContextualAction(style: .normal, title: "View") { action, view, completion in
			let detailVC = WIFIDetailVC()
			let navController = UINavigationController(rootViewController: detailVC)
			self.present(navController, animated: true)
			completion(true)
		}

		let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { action, view, completion in
			completion(true)
		}
		detailAction.backgroundColor = .miTintColor
		detailAction.image = UIImage(systemName: "qrcode")

		favoriteAction.backgroundColor = .systemOrange
		favoriteAction.image = UIImage(systemName: "star.fill")

		let configuration = UISwipeActionsConfiguration(actions: [favoriteAction, detailAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
			completion(true)
		}

		action.image = UIImage(systemName: "trash.fill")
		action.backgroundColor = .systemPink
		let configuration = UISwipeActionsConfiguration(actions: [action])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = UIColor.miTintColor.withAlphaComponent(0.2)
			return view
		}()

		let cell = tableView.dequeueReusableCell(withIdentifier: "WifiCell", for: indexPath)
		cell.textLabel?.text = "Wifi Name"
		cell.imageView?.tintColor = .miTintColor
		cell.imageView?.image = UIImage(systemName: "house.fill")
		cell.accessoryType = .disclosureIndicator

		cell.selectedBackgroundView = backgroundView

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailVC = WIFIDetailVC()
		navigationController?.pushViewController(detailVC, animated: true)
	}
}
