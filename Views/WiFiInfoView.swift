//
//  WiFiInfoView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/22/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import LocalAuthentication
import UIKit

protocol WiFiInfoViewDelegate: AnyObject {
	func showPasswordRequestedFailed()
	func biometricAuthenticationNotAvailable()
}

class WiFiInfoView: UIView {

	var wifi: Wifi

	let tapToRevealStr = "Tap to Reveal"

	var isRevealed: Bool = false {
		didSet {
			updatePasswordText()
		}
	}

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

	var delegate: WiFiInfoViewDelegate?


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


	private func updatePasswordText() {
		guard passwordValueLabel.text != "No Password" else { return }
		if isRevealed {
			UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
			UIView.animate(withDuration: 0.5) {
				guard let id = self.wifi.passwordID else { return }
				self.passwordValueLabel.textColor = .label
				self.passwordValueLabel.text = KeychainWrapper.standard.string(forKey: id.uuidString)
				self.passwordValueLabel.alpha = 1
			}
		} else {
			UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
			UIView.animate(withDuration: 0.5) {
				self.passwordValueLabel.textColor = .miTintColor
				self.passwordValueLabel.text = self.tapToRevealStr
				self.passwordValueLabel.alpha = 1
			}
		}
	}

	private func fetchPasswordFromKeychain() -> String? {
		guard let id = wifi.passwordID else { return nil }
		let password = KeychainWrapper.standard.string(forKey: id.uuidString)
		return password
	}


	private func loadContent() {
		networkImageView.icon = .network
		passwordImageView.icon = .password

		networkHeaderLabel.text = "Network"
		passwordHeaderLabel.text = "Password"

		networkValueLabel.text = wifi.networkName

		if let password = fetchPasswordFromKeychain() {
			if password == "" {
				passwordValueLabel.text = "No Password"
				passwordValueLabel.textColor = .secondaryLabel
			} else {
				passwordValueLabel.text = tapToRevealStr
				passwordValueLabel.textColor = .miTintColor
			}
		}
	}

	#warning("Refactor tap gesture to be on WiFiInfoView to get alerts presenting on DetailVC")
	@objc private func revealPassword(_ sender: UITapGestureRecognizer) {
		let context = LAContext()
		var error: NSError?

		guard passwordValueLabel.text == tapToRevealStr else {
			isRevealed = false
			return
		}

		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "We need to make sure you're authorized to view the password"

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
				guard let self = self else { return }
				DispatchQueue.main.async {
					if success {
						self.isRevealed = true
					} else {
						self.delegate?.showPasswordRequestedFailed()
					}
				}
			}
		} else {
			self.delegate?.biometricAuthenticationNotAvailable()
		}
	}
}
