//
//  MiWiFiBarButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/4/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiBarButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? .miHighlightBGColor : .miButtonBGColor
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureButton()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = 6
		clipsToBounds = true
		layer.cornerCurve = .continuous
	}

	init(backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor, title: String, imageStr: String?) {
		super.init(frame: .zero)
		configureButton()
		adjustsImageWhenHighlighted = false
		setTitleColor(textColor, for: .normal)
		setTitleColor(textColor.withAlphaComponent(0.8), for: .highlighted)
		self.tintColor = tintColor
		self.backgroundColor = backgroundColor.withAlphaComponent(0.15)
		self.setTitle(title, for: .normal)
		if let imageStr = imageStr {
			self.setImage(UIImage(systemName: imageStr), for: .normal)
		}
	}

	private func configureButton() {
		translatesAutoresizingMaskIntoConstraints = false
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
		self.contentEdgeInsets = UIEdgeInsets(top: 3, left: 7, bottom: 3, right: 7)
	}
}
