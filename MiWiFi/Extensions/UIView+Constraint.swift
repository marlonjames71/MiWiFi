//
//  UIView+Constraint.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIView {
	func constrain(subview: UIView, inset: UIEdgeInsets = .zero) {
		guard subview.isDescendant(of: self) else {
			print("Need to add subview: \(subview) to parent: \(self) first.")
			return
		}
		
		subview.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			subview.topAnchor.constraint(equalTo: self.topAnchor, constant: inset.top),
			subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset.leading),
			subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset.bottom),
			subview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset.trailing),
		])
	}
}

extension UIEdgeInsets {
	var leading: CGFloat {
		get { left }
		set { left = newValue }
	}

	var trailing: CGFloat {
		get { right }
		set { right = newValue }
	}

	init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}

	init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
		self.init(top: top, left: leading, bottom: bottom, right: trailing)
	}
}
