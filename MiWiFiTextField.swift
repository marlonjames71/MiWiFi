//
//  MiWiFiTextField.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiTextField: UITextField {

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(isSecureEntry: Bool, placeholder: String, autocorrectionType: UITextAutocorrectionType, autocapitalizationType: UITextAutocapitalizationType) {
		super.init(frame: .zero)
		isSecureTextEntry = isSecureEntry
		self.autocorrectionType = autocorrectionType
		self.placeholder = placeholder
		self.autocapitalizationType = autocapitalizationType
	}

	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false

		textColor = .label
		font = UIFont.preferredFont(forTextStyle: .title3)
		adjustsFontSizeToFitWidth = true
		minimumFontSize = 12
		clearButtonMode = .whileEditing
	}

}
