//
//  SubtitleTableViewCell.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsCell: UITableViewCell {

	var shouldHideSwitch: Bool = true {
		didSet {
			faceIDSwitch.isHidden = shouldHideSwitch
		}
	}

	private var faceIDSwitch = UISwitch()

	weak var delegate: FaceIDAlertDelegate?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		configureSwitch()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureSwitch() {
		contentView.addSubview(faceIDSwitch)
		faceIDSwitch.translatesAutoresizingMaskIntoConstraints = false

		faceIDSwitch.addTarget(self, action: #selector(sliderChangedValue(_:)), for: .valueChanged)
		faceIDSwitch.onTintColor = .miFavoriteTint
		faceIDSwitch.thumbTintColor = UIColor.miSecondaryBackground

		faceIDSwitch.isOn = DefaultsManager.faceIDEnabled

		NSLayoutConstraint.activate([
			faceIDSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			faceIDSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])

		faceIDSwitch.isHidden = shouldHideSwitch
	}


	@objc private func sliderChangedValue(_ sender: UISwitch) {
//		if slider is on then request authorization to turn off
//		- slider gets triggered
//		- sends request to check auth to VC
//		- VC checks auth and returns a bool or success/failure
//		- Slider waits for return value

//		if slider is off then turn it on and save newValue to disk using UserDefaults
		if sender.isOn == false {
			requestAuth()
		} else {
			sender.isOn = true
			DefaultsManager.faceIDEnabled = sender.isOn
		}
	}


	private func requestAuth() {
		let context = LAContext()
		context.localizedFallbackTitle = "Please use your passcode"
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			let reason = "Authentication is required for you to continue"

			let biometricType = context.biometryType == .faceID ? "Face ID" : "Touch ID"
			print("Supported Biometric type is: \(biometricType)")

			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
				guard let self = self else { return }
				DispatchQueue.main.async {
					if success {
						self.faceIDSwitch.isOn = false
						DefaultsManager.faceIDEnabled = self.faceIDSwitch.isOn
					} else {
						self.faceIDSwitch.isOn = true
						DefaultsManager.faceIDEnabled = self.faceIDSwitch.isOn
						guard let error = error as? LAError else { return }
						NSLog(error.code.getErrorDescription())
						self.delegate?.showPasswordRequestedFailed()
					}
				}
			}
		} else {
			NSLog("Biometric security not available.")
			self.delegate?.biometricAuthenticationNotAvailable()
		}
	}
}
