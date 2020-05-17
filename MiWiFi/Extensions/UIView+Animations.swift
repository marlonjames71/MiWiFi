//
//  UIView+Animations.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIView {
	func animateFromBottomWithTranslationTo(x: CGFloat, y: CGFloat) {
		UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
			self.alpha = 1
			self.transform = CGAffineTransform(translationX: x, y: y)
		}) { _ in
			UIView.animate(withDuration: 0.2, delay: 1.3, options: [], animations: {
				self.transform = .identity
				self.alpha = 0
			})
		}
	}
}
