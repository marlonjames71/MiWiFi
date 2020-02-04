//
//  MiWiFiTextFieldView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiTextFieldView: UIView {

	let textField = UITextField()
	let iconImageView = UIImageView()
	let container = UIView()
	let contextLabel = MiWiFiPlaceholderLabel(textAlignment: .center, fontSize: 11)

	let activeColor = UIColor.miTintColor.cgColor
	let inactiveColor = UIColor.secondaryLabel.cgColor


	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .black
		translatesAutoresizingMaskIntoConstraints = false
		configureCointainer()
		configureTextField()
		configurePlaceholderLabel()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	init(isSecureEntry: Bool, placeholder: String) {
		super.init(frame: .zero)
		textField.isSecureTextEntry = isSecureEntry
		contextLabel.text = placeholder
	}


	private func configureCointainer() {
		addSubview(container)
		container.translatesAutoresizingMaskIntoConstraints = false

		container.backgroundColor = .clear
		container.clipsToBounds = true
		container.layer.cornerRadius = 12
		container.layer.cornerCurve = .continuous

		container.layer.borderColor = textField.becomeFirstResponder() ? activeColor : inactiveColor
		container.layer.borderWidth = 1

		let padding: CGFloat = 12
		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
			container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
		])
	}


	private func configureTextField() {
		container.addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false

		textField.textColor = .label
		textField.font = UIFont.preferredFont(forTextStyle: .body)
		textField.adjustsFontSizeToFitWidth = true
		textField.keyboardType = .asciiCapable
		textField.minimumFontSize = 12
		textField.clearButtonMode = .whileEditing

		NSLayoutConstraint.activate([
			textField.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
			textField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
			textField.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
			textField.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 8),
			textField.heightAnchor.constraint(equalToConstant: 40)
		])
	}


	private func configurePlaceholderLabel() {
		container.addSubview(contextLabel)

		contextLabel.textColor = textField.isFirstResponder ? .miTintColor : .secondaryLabel

		NSLayoutConstraint.activate([
			contextLabel.heightAnchor.constraint(equalToConstant: 13),
			contextLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
			contextLabel.centerYAnchor.constraint(equalTo: container.topAnchor, constant: 0)
		])
	}


	private func drawBorder() {

	}
}
