//
//  MiWiFiContainerView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiContainerView: UIView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configure() {
		backgroundColor = .miBackground
		layer.cornerRadius = 16
		layer.cornerCurve = .continuous
		layer.borderWidth = 1
		layer.borderColor = UIColor.miGlobalTint.cgColor
		translatesAutoresizingMaskIntoConstraints = false
	}
}
