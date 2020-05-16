//
//  MiWiFiSaveButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiSaveButton: UIButton {

    override var isHighlighted: Bool {
		didSet { self.backgroundColor = self.isHighlighted ? UIColor.miGlobalTint.withAlphaComponent(0.7) : .miGlobalTint }
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

		self.setTitle("Save", for: .normal)
		titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

		self.backgroundColor = .miGlobalTint
		self.tintColor = .miGlobalTint
		setTitleColor(.miBackground, for: .normal)
		//self.setTitleColor(.white, for: .highlighted)

		layer.cornerRadius = 8

		contentEdgeInsets.top = 7
		contentEdgeInsets.bottom = 7
		translatesAutoresizingMaskIntoConstraints = false
	}

}
