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

	override init(frame: CGRect) {
		super.init(frame: frame)
//		backgroundColor = .clear
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

	private func configureTextField() {
		addSubview(textField)
		translatesAutoresizingMaskIntoConstraints = false

//		textField.borderStyle = .line
		textField.layer.borderColor = UIColor.systemGray4.cgColor
		textField.layer.borderWidth = 1
		textField.textColor = .label
		textField.font = UIFont.preferredFont(forTextStyle: .title3)
		textField.adjustsFontSizeToFitWidth = true
		textField.autocorrectionType = .yes
		textField.minimumFontSize = 12
		textField.clearButtonMode = .whileEditing
		NSLayoutConstraint.activate([
			textField.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 8),
			textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			textField.heightAnchor.constraint(equalToConstant: 50)
		])
	}
}