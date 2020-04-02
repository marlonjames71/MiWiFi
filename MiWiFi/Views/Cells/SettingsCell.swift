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

	weak var delegate: FaceIDManagerDelegate?

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

		faceIDSwitch.addTarget(self, action: #selector(switchChangedValue(_:)), for: .valueChanged)
		faceIDSwitch.onTintColor = .miFavoriteTint
		faceIDSwitch.thumbTintColor = UIColor.miSecondaryBackground

		faceIDSwitch.isOn = DefaultsManager.faceIDEnabled

		NSLayoutConstraint.activate([
			faceIDSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
			faceIDSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])

		faceIDSwitch.isHidden = shouldHideSwitch
	}


	@objc private func switchChangedValue(_ sender: UISwitch) {
		if sender.isOn == false {
			FaceIDManager.requestAuth { success, authError in
				DispatchQueue.main.async {
					if success {
						self.faceIDSwitch.isOn = false
						DefaultsManager.faceIDEnabled = self.faceIDSwitch.isOn
					} else {
						self.faceIDSwitch.isOn = true
						DefaultsManager.faceIDEnabled = self.faceIDSwitch.isOn
						guard let error = authError as? LAError else { return }
						NSLog(error.code.getErrorDescription())
						self.delegate?.showPasswordRequestedFailed()
					}
				}
			}
		} else {
			sender.isOn = true
			DefaultsManager.faceIDEnabled = sender.isOn
		}
	}
}
