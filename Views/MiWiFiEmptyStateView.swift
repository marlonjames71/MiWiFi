//
//  MiWiFiEmptyStateView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/28/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiEmptyStateView: UIView {

	let messageLabel = MiWiFiBodyLabel(textAlignment: .center, fontSize: 24)
	let logoImageView = UIImageView()

	lazy var iPhone8Anchors = (trailing: logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 194),
							   bottom: logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 22))

	lazy var iPhone8PlusAnchors = (trailing: logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 219),
								   bottom: logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 34))

	lazy var iPhoneXAnchors = (trailing: logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 193.5), // 194
							   bottom: logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)) // 22

	lazy var iPhoneXSMaxAnchors = (trailing: logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 219),
								   bottom: logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1))


	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(message: String) {
		super.init(frame: .zero)
		messageLabel.text = message
		configure()
		print(UIScreen.main.bounds.height)
	}

	private func configure() {
		addSubview(messageLabel)
		addSubview(logoImageView)

		messageLabel.numberOfLines = 3
		messageLabel.textColor = .secondaryLabel

		logoImageView.image = UIImage(named: "wifiemptystate")
		logoImageView.tintColor = .miGrayColor
		logoImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
			messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
			messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
			messageLabel.heightAnchor.constraint(equalToConstant: 200),

			logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
			logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3)
		])

		if UIScreen.main.bounds.height == 667 {
			NSLayoutConstraint.activate([
				iPhone8Anchors.trailing,
				iPhone8Anchors.bottom
			])
		} else if UIScreen.main.bounds.height == 896 {
			NSLayoutConstraint.activate([
				iPhoneXSMaxAnchors.trailing,
				iPhoneXSMaxAnchors.bottom
			])
		} else if UIScreen.main.bounds.height == 736 {
			NSLayoutConstraint.activate([
				iPhone8PlusAnchors.trailing,
				iPhone8PlusAnchors.bottom
			])
		} else if UIScreen.main.bounds.height == 812 {
			NSLayoutConstraint.activate([
				iPhoneXAnchors.trailing,
				iPhoneXAnchors.bottom
			])
		}
	}
}
