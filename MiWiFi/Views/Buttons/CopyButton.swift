//
//  CopyButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class CopyButton: UIButton {

	override var isHighlighted: Bool {
		didSet {
			self.backgroundColor = self.isHighlighted ? .miHighlightBGColor : .miButtonBGColor

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

	override func draw(_ rect: CGRect) {
		layer.cornerRadius = frame.height / 2
		layer.cornerCurve = .continuous
		clipsToBounds = true
	}


	// MARK: - Configuration
	private func configureButton() {
		let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
		setImage(UIImage(systemName: "doc.on.clipboard", withConfiguration: configuration), for: .normal)

		self.backgroundColor = .miButtonBGColor
		self.tintColor = .miGlobalTint
		setTitleColor(.miGlobalTint, for: .normal)
		adjustsImageWhenHighlighted = false

		contentEdgeInsets.top = 7
		contentEdgeInsets.bottom = 7
		translatesAutoresizingMaskIntoConstraints = false
	}

}
