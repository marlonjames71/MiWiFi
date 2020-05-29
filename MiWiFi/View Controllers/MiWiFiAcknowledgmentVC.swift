//
//  MiWiFiAcknowledgmentVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import SafariServices

class MiWiFiAcknowledgmentVC: UIViewController, UITextViewDelegate {

	private let creditView = CreditView()

	var isCreditViewOffCentered: Bool?

	weak var delegate: WiFiSettingsVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
		let blurEffect = UIBlurEffect(style: .regular)
		let effectView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.3)
		view.addSubview(effectView)
		effectView.frame = view.bounds

		isCreditViewOffCentered = true
		configureCreditView()
		setupCreditViewForAnimation()

    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animate()
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		animate()
	}


	private func configureCreditView() {
		view.addSubview(creditView)
		creditView.delegate = self

		creditView.alpha = 0

		NSLayoutConstraint.activate([
			creditView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			creditView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			creditView.widthAnchor.constraint(equalToConstant: 300),
		])
	}


	private func setupCreditViewForAnimation() {
		let destination = CGPoint(x: view.frame.midX, y: view.frame.midY + (creditView.frame.height / 2))
		let offset = view.convert(destination, to: creditView)
		creditView.transform = CGAffineTransform(translationX: 0, y: offset.y)
		creditView.alpha = 0
	}


	private func animate() {
		if isCreditViewOffCentered! {
			isCreditViewOffCentered = false
			UIView.animate(withDuration: 0.8,
						   delay: 0,
						   usingSpringWithDamping: 0.7,
						   initialSpringVelocity: 0.6,
						   options: [.curveEaseOut],
						   animations: {
				self.creditView.transform = .identity
				self.creditView.alpha = 1
			})
		} else {
			isCreditViewOffCentered = true
			UIView.animate(withDuration: 0.3) {
				self.creditView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.midY + self.creditView.frame.height)
				self.creditView.alpha = 0
			}
		}
	}
}


extension MiWiFiAcknowledgmentVC: CreditViewDelegate {
	func dismissTapped() {
		dismiss(animated: true) {
			self.delegate.deselectRow()
		}
	}

	func needsSafariVCPresented(with url: URL) {
		presentSafariVC(with: url)
	}
}
