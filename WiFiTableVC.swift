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
	let addWiFiButton = MiWiFiButton(backgroundColor: .miwifiButtonBGColor,
									 tintColor: .systemBlue,
									 textColor: .systemBlue,
									 title: "Add WiFi",
									 image: UIImage(systemName: "plus.circle"))


	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.systemBlue]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.systemBlue]
		configureListTableView()
		configureAddWIFIButton()
    }

	private func configureListTableView() {
		view.addSubview(wifiTableView)
		wifiTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			wifiTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			wifiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			wifiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			wifiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
		])
		wifiTableView.tableFooterView = UIView()
		wifiTableView.dataSource = self
		wifiTableView.delegate = self
		wifiTableView.register(UITableViewCell.self, forCellReuseIdentifier: "WifiCell")
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

	private func configureAndPresentAddWifiAlert() {
		let addWifiAlertVC = UIAlertController(title: "Add New WiFi", message: nil, preferredStyle: .alert)
		let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
			// Save code goes here
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		addWifiAlertVC.addTextField { wifiNameTextField in
			wifiNameTextField.placeholder =  "WiFi Name"
		}
		addWifiAlertVC.addTextField { wifiPasswordTextField in
			wifiPasswordTextField.placeholder = "WiFi Password"
			wifiPasswordTextField.isSecureTextEntry = true
		}
		[saveAction, cancelAction].forEach { addWifiAlertVC.addAction($0) }
		present(addWifiAlertVC, animated: true)
	}

	// MARK: - Actions
	@objc private func addWifiButtonTapped() {
		configureAndPresentAddWifiAlert()
	}
}

extension WiFiTableVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		10
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WifiCell", for: indexPath)
		cell.textLabel?.text = "Wifi Name"
		cell.accessoryType = .disclosureIndicator
		
		return cell
	}
}
