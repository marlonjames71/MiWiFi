//
//  MiWiFiButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureButton()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor, title: String, image: UIImage?) {
		super.init(frame: .zero)
		setTitleColor(textColor, for: .normal)
		self.tintColor = tintColor
		self.backgroundColor = backgroundColor
		self.setTitle(title, for: .normal)
		self.setImage(image, for: .normal)
		configureButton()
	}

	private func configureButton() {
		layer.cornerRadius = 10
		layer.cornerCurve = .continuous
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
		translatesAutoresizingMaskIntoConstraints = false
	}

}
