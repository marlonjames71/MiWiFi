//
//  MiWiFiContainerView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class ISPContainerView: UIView {

	let isp: ISP
	lazy var phoneButton = CallButton(frame: .zero, name: "\(isp.name ?? "")")

	init(frame: CGRect = .zero, isp: ISP) {
		self.isp = isp
		super.init(frame: frame)
		configureMainView()
	}

	override init(frame: CGRect) {
		fatalError("Use init with isp: ISP")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureMainView() {
		// Configure View
		backgroundColor = .miBackground
		layer.cornerRadius = 16
		layer.cornerCurve = .continuous
		layer.borderWidth = 1
		layer.borderColor = UIColor.miGlobalTint.cgColor
		translatesAutoresizingMaskIntoConstraints = false

		// Configure Phone Button
		phoneButton.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
	}


	@objc private func makeCall(_ sender: CallButton) {
		guard let number = isp.phone,
			let numberURL = URL(string: "tel://" + number) else { return }
		let app = UIApplication.shared
		if app.canOpenURL(numberURL) {
			app.canOpenURL(numberURL)
		}
	}
}
