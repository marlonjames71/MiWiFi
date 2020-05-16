//
//  AddISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/12/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

final class AddISPVC: UIViewController {

	// MARK: - Properties
	private lazy var ispInputView = ISPInputView(with: self)
	private let haptic = UIImpactFeedbackGenerator(style: .medium)


	// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureInputView()
		setupInputViewShadow()
		haptic.prepare()
    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		inputViewAnimateIn()
	}


	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		setupInputViewShadow()
	}

// MARK: - Configure Methods
	private func configureView() {
		view.backgroundColor = nil

		let blurEffect = UIBlurEffect(style: .regular)
//		let effectView = UIVisualEffectView(effect: blurEffect)
		let effectView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.4)
		view.addSubview(effectView)
		effectView.frame = view.bounds

//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
//		view.addGestureRecognizer(tapGesture)
	}


	private func configureInputView() {
		view.addSubview(ispInputView)

		let top = ispInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
		top.priority = .defaultLow
		top.isActive = true

		NSLayoutConstraint.activate([
			ispInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			ispInputView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
			ispInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
		])

		ispInputView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
	}


	private func setupInputViewShadow() {
		ispInputView.layer.shadowPath = UIBezierPath(rect: ispInputView.bounds).cgPath
		ispInputView.layer.shadowRadius = 14
		ispInputView.layer.shadowOffset = .zero
		ispInputView.layer.shadowOpacity = 0.2
	}


	// MARK: - Helper Methods
	@objc private func inputViewAnimateIn() {
		guard ispInputView.transform != .identity else { return }
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
			self.ispInputView.transform = .identity
		}, completion: { _ in
			self.haptic.impactOccurred()
		})
	}


	@objc private func inputViewAnimateOut() {
		UIView.animate(withDuration: 0.2, animations: {
			self.ispInputView.alpha = 0
			self.ispInputView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
		})

		self.dismissVC()
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}
}


extension AddISPVC: ISPInputViewDelegate {
	func dismissView() {
		inputViewAnimateOut()
	}
}
