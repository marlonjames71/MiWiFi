//
//  MiWiFiContainerView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData
import LinkPresentation

protocol ISPContainerViewDelegate: class {
	func showCopyAlert()
}

class ISPContainerView: UIView {

	let isp: ISP
	lazy var callButton = CallButton(frame: .zero, isp: isp)
	lazy var copyButton = CopyButton()

	weak var delegate: ISPContainerViewDelegate?

	init(frame: CGRect = .zero, isp: ISP) {
		self.isp = isp
		super.init(frame: frame)
		configureMainView()
		configureButtons()
	}

	override init(frame: CGRect) {
		fatalError("Use init with isp: ISP")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureMainView() {
		// Configure View
		backgroundColor = .miSecondaryBackground
		layer.cornerRadius = 16
		layer.cornerCurve = .continuous
		translatesAutoresizingMaskIntoConstraints = false
	}


	private func configureButtons() {
		addSubview(callButton)
		addSubview(copyButton)
		callButton.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
		copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)

//		let stackView = UIStackView.fillStackView(axis: .horizontal, spacing: 8, with: [callButton, copyButton])
//		self.addSubview(stackView)

		NSLayoutConstraint.activate([
			callButton.heightAnchor.constraint(equalToConstant: 50),
			copyButton.heightAnchor.constraint(equalToConstant: 50),
			copyButton.widthAnchor.constraint(equalToConstant: 50),

			callButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			callButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			callButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
			callButton.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -8),

			copyButton.topAnchor.constraint(equalTo: callButton.topAnchor),
			copyButton.bottomAnchor.constraint(equalTo: callButton.bottomAnchor),
			copyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)

//			stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//			stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//			stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
//			stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
		])
	}


	private func open(_ url: URL) {
		let app = UIApplication.shared
		if app.canOpenURL(url) {
			app.open(url, options: [:])
		}
	}


	@objc private func makeCall(_ sender: CallButton) {
		guard let number = isp.phone,
			let numberURL = URL(string: "tel:\(number)") else { return }
		open(numberURL)
	}


	@objc private func copyButtonTapped() {
		guard let number = isp.phone else { return }
		delegate?.showCopyAlert()
		let pasteboard = UIPasteboard.general
		pasteboard.string = number
	}
}
