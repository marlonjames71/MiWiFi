//
//  WIFIDetailVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/10/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class WIFIDetailVC: UIViewController {

	var wifiController: WifiController?
	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		configureNavController()
		updateViews()
    }

	private func updateViews() {
		guard let wifi = wifi else { return }
		title = wifi.name

		let qrImageView = MiWiFiImageView(with: wifi)
		layoutImageView(imageView: qrImageView)
	}

	private func configureNavController() {
		title = "WiFi Name"
		let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
		editButton.tintColor = .miTintColor
		navigationItem.rightBarButtonItem = editButton
	}

	private func layoutImageView(imageView: UIImageView) {
		view.addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])
	}

	@objc private func editButtonTapped(_ sender: UIBarButtonItem) {
		guard let wifi = wifi else { return }
		let editVC = AddWIFIVC()
		editVC.wifi = wifi
		editVC.modalPresentationStyle = .overFullScreen
		present(editVC, animated: true)
	}
}



