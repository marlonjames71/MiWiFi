//
//  MiWiFiImageView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import QRettyCode

class MiWiFiImageView: UIImageView {

	let placeholderImage = UIImage(systemName: "qrcode")!

	private let wifi: Wifi

	override init(frame: CGRect) {
		fatalError("Use init(frame with wifi)")
	}

	init(frame: CGRect = .zero, with wifi: Wifi) {
		self.wifi = wifi
		super.init(frame: frame)
		configure()
		configureQRCode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		configureQRCode()
	}

	private func configure() {
		layer.cornerCurve = .continuous
		layer.cornerRadius = 12
		clipsToBounds = true
		contentMode = .scaleAspectFit
		image = placeholderImage
		translatesAutoresizingMaskIntoConstraints = false

	}

	func configureQRCode() {
		let qrData = configureWifiCodeString().data(using: .utf8)
		let qrGen = QRettyCodeImageGenerator(data: qrData, correctionLevel: .H, size: self.frame.width, style: .dots)
		qrGen.renderEffects = true
		qrGen.gradientStyle = .linear
		qrGen.gradientBackgroundVisible = false
		qrGen.gradientStartColor = .miNeonYellowGreen
		qrGen.gradientEndColor = .miNeonTeal
		qrGen.gradientStartPoint = CGPoint(x: 0.2, y: 0.4)
		qrGen.gradientEndPoint = CGPoint(x: 1, y: 1)

		self.image = qrGen.image
	}

	private func configureWifiCodeString() -> String {
		guard let id = wifi.passwordID else { return "" }
		let password = KeychainWrapper.standard.string(forKey: id.uuidString)
		let pass = password != "" ? password : "nopass"
		let network = wifi.networkName ?? "NoName"

		if pass == "nopass" {
			return #"WIFI:S:"\#(network)";;"#
		} else {
			return #"WIFI:T:WPA;S:"\#(network);P:"\#(pass ?? "No Password")";;"#
		}
	}
}
