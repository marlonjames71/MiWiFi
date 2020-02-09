//
//  SubtitleTableViewCell.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	let lockImageView = UIImageView()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func updateViews() {
		guard let wifi = wifi else { return }
		textLabel?.text = wifi.nickname
		detailTextLabel?.text = wifi.networkName

		if let id = wifi.passwordID {
			let password = KeychainWrapper.standard.string(forKey: id.uuidString)
			if password == "" {
				detailTextLabel?.textColor = .systemGray2
			} else {
				detailTextLabel?.textColor = .secondaryLabel
			}
		}

		imageView?.tintColor = wifi.isFavorite == true ? UIColor.miFavoriteTint : UIColor.miIconTint
		imageView?.image = UIImage(systemName: wifi.iconName ?? "house.fill")
		accessoryType = .disclosureIndicator

		configureImageView()
	}


	private func configureImageView() {
		addSubview(lockImageView)
		lockImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			lockImageView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -16),
			lockImageView.heightAnchor.constraint(equalToConstant: 16),
			lockImageView.widthAnchor.constraint(equalTo: lockImageView.heightAnchor),
			lockImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
		])

		guard let id = wifi?.passwordID?.uuidString else { return }
		let password = KeychainWrapper.standard.string(forKey: id)
		lockImageView.tintColor = password != "" ? .miSecondaryAccent : .secondaryLabel
		lockImageView.image = password != "" ? UIImage(systemName: "lock.fill") : UIImage(systemName: "lock.slash.fill")
	}

}
