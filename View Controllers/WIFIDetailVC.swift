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

	let wifi: Wifi

	let qrImageView: MiWiFiImageView

	init(with wifi: Wifi) {
		self.wifi = wifi
		self.qrImageView = MiWiFiImageView(with: wifi)
		super.init(nibName: nil, bundle: nil)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("Use init(with wifi: Wifi)")
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavController()
		configureView()
		configureWifiInfoView()
    }

	private func configureView() {
		view.backgroundColor = .miBackground
		layoutImageView(imageView: qrImageView)
	}

	private func configureNavController() {
		title = wifi.name
		let star = UIImage(systemName: "star.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
		let starImageView = UIImageView(image: star)

		if wifi.isFavorite {
			navigationItem.titleView = starImageView
		}

		let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
		editButton.tintColor = .miTintColor
		navigationItem.rightBarButtonItem = editButton
	}

	private func layoutImageView(imageView: UIImageView) {
		view.addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])
	}

	private func configureWifiInfoView() {
		let infoView = WiFiInfoView(with: wifi)

		view.addSubview(infoView)
		NSLayoutConstraint.activate([
			infoView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 30),
			infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
		])
	}

	@objc private func editButtonTapped(_ sender: UIBarButtonItem) {
		let editVC = AddWIFIVC()
		editVC.wifi = wifi
		editVC.modalPresentationStyle = .overFullScreen
		present(editVC, animated: true)
	}
}



