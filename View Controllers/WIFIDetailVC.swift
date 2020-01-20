//
//  WIFIDetailVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/10/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class WIFIDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground
		configureNavController()
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



