//
//  WiFiInfoView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/22/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import LocalAuthentication
import UIKit

class WiFiInfoView: UIView {

	enum RevealState {
		case revealed
		case hidden
		case noPassword
	}

	var wifi: Wifi

	let tapToRevealStr = "Tap to Reveal"

	var isRevealed: RevealState = .hidden {
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

	lazy var color: UIColor = wifi.isFavorite ? .miSecondaryAccent : .miGlobalTint


	init(frame: CGRect = .zero, with wifi: Wifi) {
		self.wifi = wifi
		super.init(frame: frame)
		configureView()
		configureLayout()
		loadContent()
		configureTapGesture()
		configureIntialPasswordRevealState(wifi: wifi)
	}


	override init(frame: CGRect) {
		fatalError("Use init(frame with wifi")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureIntialPasswordRevealState(wifi: Wifi) {
		let password = fetchPasswordFromKeychain(wifi: wifi)
		if password == "" {
			isRevealed = .noPassword
		} else {
			isRevealed = .hidden
		}
	}


	func configureView() {
		backgroundColor = .clear
		clipsToBounds = true
		translatesAutoresizingMaskIntoConstraints = false
		[networkImageView, passwordImageView].forEach { $0.tintColor = .miGlobalTint }
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
		if isRevealed == .revealed {
			UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
			UIView.animate(withDuration: 0.5) {
				guard let id = self.wifi.passwordID else { return }
				self.passwordValueLabel.textColor = .label
				self.passwordValueLabel.text = KeychainWrapper.standard.string(forKey: id.uuidString)
				self.passwordValueLabel.alpha = 1
				self.passwordHeaderLabel.text = "Tap To Hide Password"
			}
		} else {
			UIView.animate(withDuration: 0.5) { self.passwordValueLabel.alpha = 0 }
			UIView.animate(withDuration: 0.5) {
				self.passwordValueLabel.textColor = .miGlobalTint
				self.passwordValueLabel.text = self.tapToRevealStr
				self.passwordValueLabel.alpha = 1
				self.passwordHeaderLabel.text = "Password"
			}
		}
	}

	private func fetchPasswordFromKeychain(wifi: Wifi) -> String? {
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

		if let password = fetchPasswordFromKeychain(wifi: wifi) {
			if password == "" {
				passwordValueLabel.text = "No Password"
				passwordValueLabel.textColor = .secondaryLabel
			} else {
				passwordValueLabel.text = tapToRevealStr
				passwordValueLabel.textColor = .miGlobalTint
			}
		}
	}

	
	@objc private func revealPassword(_ sender: UITapGestureRecognizer) {

		guard passwordValueLabel.text == tapToRevealStr else {
			isRevealed = .hidden
			return
		}

		if DefaultsManager.faceIDEnabled {
			FaceIDManager.requestAuth { success, authError in
				DispatchQueue.main.async {
					if success {
						self.isRevealed = .revealed
					} else {
						guard let error = authError as? LAError else { return }
						NSLog(error.code.getErrorDescription())
					}
				}
			}
		} else {
			self.isRevealed = .revealed
		}
	}
}
