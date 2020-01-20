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
    }

	private func updateViews() {
		guard let wifi = wifi else { return }
		title = wifi.name
	}

	private func configureNavController() {
		title = "WiFi Name"
		let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
		editButton.tintColor = .miTintColor
		navigationItem.rightBarButtonItem = editButton
	}

	@objc private func editButtonTapped(_ sender: UIBarButtonItem) {
		print("Edit tapped")
	}
}



