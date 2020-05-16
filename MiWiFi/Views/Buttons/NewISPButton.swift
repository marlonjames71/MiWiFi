//
//  NewISPButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/12/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class NewISPButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			self.backgroundColor = self.isHighlighted ? .miHighlightBGColor : .miButtonBGColor
			self.layer.borderColor = self.isHighlighted ? UIColor.miHighlightBGColor.cgColor : UIColor.miButtonBorderColor.cgColor
		}
	}


	// MARK: - Init Methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureButton()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Configuration
	private func configureButton() {
		layer.cornerRadius = 10
		layer.cornerCurve = .continuous

		self.setTitle("+ Add New", for: .normal)
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

		self.backgroundColor = .miButtonBGColor
		self.tintColor = .miGlobalTint
		setTitleColor(.miGlobalTint, for: .normal)
		layer.borderWidth = 1
		layer.borderColor = UIColor.miButtonBorderColor.cgColor
		//self.setTitleColor(.white, for: .highlighted)

		layer.cornerRadius = 8

		contentEdgeInsets.top = 7
		contentEdgeInsets.bottom = 7
		translatesAutoresizingMaskIntoConstraints = false
	}
}
