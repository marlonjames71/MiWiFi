//
//  CallButton.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class CallButton: UIButton {

    override var isHighlighted: Bool {
		didSet {
			self.backgroundColor = self.isHighlighted ? .miHighlightBGColor : .miButtonBGColor
			
		}
	}

	private let isp: ISP



	// MARK: - Init Methods
	init(frame: CGRect = .zero, isp: ISP) {
		self.isp = isp
		super.init(frame: frame)
		configureButton()
	}

	override init(frame: CGRect) {
		fatalError("Use init with name: String")
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
		if isp.phone != nil {
			self.setTitle("  Call \(isp.name ?? "ISP")", for: .normal)
		} else {
			self.setTitle("No Phone Number", for: .normal)
		}

		titleLabel?.font = UIFont.rounded(from: UIFont.preferredFont(forTextStyle: .headline))
		let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
		setImage(UIImage(systemName: "phone.circle.fill", withConfiguration: configuration), for: .normal)

		self.backgroundColor = .miButtonBGColor
		self.tintColor = .miGlobalTint
		setTitleColor(.miGlobalTint, for: .normal)
		self.adjustsImageWhenHighlighted = false

		contentEdgeInsets.top = 7
		contentEdgeInsets.bottom = 7
		translatesAutoresizingMaskIntoConstraints = false
	}
}
