//
//  MiWiFiBarButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/4/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiBarButton: UIButton {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureButton()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = self.bounds.size.height / 2
		clipsToBounds = true
		layer.cornerCurve = .continuous
	}

	init(backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor, title: String, imageStr: String?) {
		super.init(frame: .zero)
		configureButton()
		setTitleColor(textColor, for: .normal)
		setTitleColor(textColor.withAlphaComponent(0.2), for: .highlighted)
		self.tintColor = tintColor
		self.backgroundColor = backgroundColor.withAlphaComponent(0.2)
		self.setTitle(title, for: .normal)
		if let imageStr = imageStr {
			self.setImage(UIImage(systemName: imageStr), for: .normal)
		}
	}

	private func configureButton() {
		translatesAutoresizingMaskIntoConstraints = false
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
		self.contentEdgeInsets = UIEdgeInsets(top: 1, left: 7, bottom: 1, right: 7)
	}
}
