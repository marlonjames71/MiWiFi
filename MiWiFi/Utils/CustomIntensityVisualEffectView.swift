//
//  CustomIntensityVisualEffectView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class CustomIntensityVisualEffectView: UIVisualEffectView {

	/// Create visual effect view with given effect and its intensity
	///
	/// - Parameters:
	///   - effect: visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	init(effect: UIVisualEffect, intensity: CGFloat) {
		super.init(effect: nil)
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
			guard let self = self else { return }
			self.effect = effect
		}
		animator.fractionComplete = intensity
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}

	// MARK: Private
	private var animator: UIViewPropertyAnimator!

}
