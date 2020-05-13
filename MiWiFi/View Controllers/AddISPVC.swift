//
//  AddISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/12/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

final class AddISPVC: UIViewController {

	let saveButton = MiWiFiBarButton(backgroundColor: UIColor.miGlobalTint.withAlphaComponent(0.1),
									 tintColor: .miGlobalTint,
									 textColor: .miGlobalTint,
									 title: "Save",
									 imageStr: nil)

	let urlTextField = MiWiFiTextField(isSecureEntry: false,
									   placeholder: "e.g. https://wesite.com",
									   autocorrectionType: .no,
									   autocapitalizationType: .none,
									   returnType: .continue)

	let phoneTextField = MiWiFiTextField(isSecureEntry: false,
										 placeholder: "e.g. 8005557171",
										 autocorrectionType: .no,
										 autocapitalizationType: .none,
										 returnType: .done)

	let dismissLabel = UILabel()


	// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureDismissLabel()
		configureSaveButton()
    }


	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 0.4) {
			self.dismissLabel.alpha = 1
		}
	}


	private func configureView() {
		view.backgroundColor = .clear

		let blur = UIBlurEffect(style: .prominent)
		let effectView = UIVisualEffectView(effect: blur)
		view.addSubview(effectView)
		effectView.translatesAutoresizingMaskIntoConstraints = false
		effectView.frame = view.bounds

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
		view.addGestureRecognizer(tapGesture)
	}


	private func configureDismissLabel() {
		view.addSubview(dismissLabel)
		dismissLabel.translatesAutoresizingMaskIntoConstraints = false
		dismissLabel.text = "Tap to Dismiss"
		dismissLabel.textColor = .secondaryLabel

		NSLayoutConstraint.activate([
			dismissLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			dismissLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
		])

		dismissLabel.alpha = 0
	}


	private func configureSaveButton() {
		view.addSubview(saveButton)
		saveButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.heightAnchor.constraint(equalToConstant: 45),
			saveButton.widthAnchor.constraint(equalToConstant: 100)
		])
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}

}
