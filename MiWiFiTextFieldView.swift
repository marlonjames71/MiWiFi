//
//  MiWiFiTextFieldView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiTextFieldView: UIView {

	let underline = UIView()
	let textField = UITextField()
	let iconImageView = UIImageView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
		configureUnderline()
		configureTextField()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(isSecureEntry: Bool, placeholder: String) {
		super.init(frame: .zero)
		textField.isSecureTextEntry = isSecureEntry
		textField.placeholder = placeholder
	}

	private func configureUnderline() {
		addSubview(underline)
		underline.translatesAutoresizingMaskIntoConstraints = false

		underline.backgroundColor = .secondaryLabel
		NSLayoutConstraint.activate([
			underline.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			underline.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
			underline.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			underline.heightAnchor.constraint(equalToConstant: 1)
		])
	}

	private func configureTextField() {
		addSubview(textField)
		translatesAutoresizingMaskIntoConstraints = false

		textField.borderStyle = .none
		textField.textColor = .label
		textField.font = UIFont.preferredFont(forTextStyle: .title3)
		textField.adjustsFontSizeToFitWidth = true
		textField.autocorrectionType = .yes
		textField.minimumFontSize = 12
		textField.clearButtonMode = .whileEditing
		NSLayoutConstraint.activate([
			textField.bottomAnchor.constraint(equalTo: underline.topAnchor, constant: 8),
			textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			textField.heightAnchor.constraint(equalToConstant: 50)
		])
	}
}
