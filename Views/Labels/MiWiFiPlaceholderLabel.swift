//
//  MiWiFiPlaceholderLabel.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/29/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiPlaceholderLabel: UILabel {

   	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
		super.init(frame: .zero)
		self.textAlignment = textAlignment
		self.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
		configure()
	}

	private func configure() {
		textColor = .miTintColor
		adjustsFontSizeToFitWidth = true
		minimumScaleFactor = 0.9
		lineBreakMode = .byTruncatingTail
		translatesAutoresizingMaskIntoConstraints = false
	}
}
