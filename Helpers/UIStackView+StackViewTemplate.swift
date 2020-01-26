//
//  UIStackview+StackViewTemplate.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/25/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIStackView {
	static func fillStackView(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat, with views: [UIView]) -> UIStackView {
		let stackView = UIStackView()
		stackView.axis = axis
		stackView.spacing = spacing
		stackView.alignment = .fill
		stackView.distribution = .fill
		views.forEach { stackView.addArrangedSubview($0) }
		return stackView
	}
}
