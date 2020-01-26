//
//  WiFiInfoView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/22/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class WiFiInfoView: UIView {

	var wifi: Wifi

	let networkHeaderLabel = MiWiFiHeaderLabel(textAlignment: .left, fontSize: 12)
	let networkValueLabel = MiWiFiBodyLabel(textAlignment: .left, fontSize: 18)
	let passwordHeaderLabel = MiWiFiHeaderLabel(textAlignment: .left, fontSize: 12)
	let passwordValueLabel = MiWiFiBodyLabel(textAlignment: .left, fontSize: 18)

	let networkImageView = MiWiFiIconImageView()
	let passwordImageView = MiWiFiIconImageView()

	var networkStackView = UIStackView()
	var passwordStackView = UIStackView()
	var mainStackView = UIStackView()

	let tapGestureRecognizer = UITapGestureRecognizer()

	init(frame: CGRect = .zero, with wifi: Wifi) {
		self.wifi = wifi
		super.init(frame: frame)
		configureView()
		configureLayout()
		loadContent()
		configureTapGesture()
	}

	override init(frame: CGRect) {
		fatalError("Use init(frame with wifi")
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureView() {
		backgroundColor = .miBackground
//		layer.cornerCurve = .continuous
//		layer.cornerRadius = 12
		clipsToBounds = true
		translatesAutoresizingMaskIntoConstraints = false
	}

	private func configureTapGesture() {
		tapGestureRecognizer.addTarget(self, action: #selector(revealPassword(_:)))
		passwordValueLabel.isUserInteractionEnabled = true
		passwordValueLabel.addGestureRecognizer(tapGestureRecognizer)
	}

	private func configureLayout() {
		let networkLabelStackView = UIStackView.fillStackView(spacing: 4, with: [networkHeaderLabel, networkValueLabel])
		let passwordLabelStackView = UIStackView.fillStackView(spacing: 4, with: [passwordHeaderLabel, passwordValueLabel])

		let divider = UIView()
		divider.backgroundColor = .tertiaryLabel

		networkStackView = UIStackView.fillStackView(axis: .horizontal, spacing: 12, with: [networkImageView, networkLabelStackView])
		passwordStackView = UIStackView.fillStackView(axis: .horizontal, spacing: 12, with: [passwordImageView, passwordLabelStackView])
		mainStackView = UIStackView.fillStackView(spacing: 10, with: [networkStackView, divider, passwordStackView])

		addSubview(mainStackView)
		mainStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			divider.heightAnchor.constraint(equalToConstant: 1),

			mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
			mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

			networkImageView.widthAnchor.constraint(equalTo: networkImageView.heightAnchor),
			passwordImageView.widthAnchor.constraint(equalTo: passwordImageView.heightAnchor),
		])
	}

	private func loadContent() {
		networkImageView.icon = .network
		passwordImageView.icon = .password

		networkHeaderLabel.text = "Network"
		passwordHeaderLabel.text = "Password"

		networkValueLabel.text = wifi.wifiName
		passwordValueLabel.text = "Tap to Reveal"
	}

	@objc private func revealPassword(_ sender: UITapGestureRecognizer) {
		print("Reveal Bitch!")
	}
}
