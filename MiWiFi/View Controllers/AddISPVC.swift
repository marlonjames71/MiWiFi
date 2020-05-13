//
//  AddISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/12/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

final class AddISPVC: UIViewController {

	private let container = UIView()

	private let saveButton = MiWiFiBarButton(backgroundColor: UIColor.miGlobalTint.withAlphaComponent(0.1),
									 tintColor: .miGlobalTint,
									 textColor: .miGlobalTint,
									 title: "Save",
									 imageStr: nil)

	private let urlTextField = MiWiFiTextFieldView(isSecureEntry: false,
											placeholder: "Website URL",
											autocorrectionType: .no,
											autocapitalizationType: .none,
											returnType: .continue)

	private let phoneTextField = MiWiFiTextFieldView(isSecureEntry: false,
											  placeholder: "Phone",
											  autocorrectionType: .no,
											  autocapitalizationType: .none,
											  returnType: .done)

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .title3)
		label.text = "Add Your ISP Info"
		label.textColor = .miTitleColor
		label.textAlignment = .left
		return label
	}()

	private lazy var dismissButton: UIButton = {
		let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
		let button = UIButton()
		button.tintColor = .miGlobalTint
		button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
		button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return button
	}()


	// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
//		configureSaveButton()
		configureContainerView()
		configureStackView()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   usingSpringWithDamping: 1.0,
					   initialSpringVelocity: 1.2,
					   options: .curveEaseOut,
					   animations: {
			self.container.transform = .identity
		})
	}


	private func configureView() {
		view.backgroundColor = .clear

		let blur = UIBlurEffect(style: .prominent)
		let effectView = UIVisualEffectView(effect: blur)
		view.addSubview(effectView)
		effectView.translatesAutoresizingMaskIntoConstraints = false
		effectView.frame = view.bounds

//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
//		view.addGestureRecognizer(tapGesture)
	}


	private func configureContainerView() {
		view.addSubview(container)
		container.translatesAutoresizingMaskIntoConstraints = false

		container.backgroundColor = .miBackground
		container.layer.cornerRadius = 16
		container.layer.cornerCurve = .continuous

		let top = container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
		top.priority = .defaultLow
		top.isActive = true

		NSLayoutConstraint.activate([
			container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			container.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
		])

		container.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
	}


	private func configureStackView() {
		let horizStackView = UIStackView(arrangedSubviews: [titleLabel, dismissButton])
		horizStackView.axis = .horizontal
		horizStackView.distribution = .fill
		horizStackView.spacing = 8

		urlTextField.textField.placeholder = "e.g. https://wesite.com"
		phoneTextField.textField.placeholder = "e.g. 8005557171"
		phoneTextField.textField.keyboardType = .numbersAndPunctuation
		let views: [UIView] = [horizStackView, urlTextField, phoneTextField]
		saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

		views.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.heightAnchor.constraint(equalToConstant: 45).isActive = true
		}

		let vertStackView = UIStackView.fillStackView(axis: .vertical, spacing: 30, with: views)
		vertStackView.addArrangedSubview(saveButton)
		container.addSubview(vertStackView)
		vertStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			vertStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
			vertStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
			vertStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
			vertStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
		])
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


	@objc private func animateOut() {
		UIView.animate(withDuration: 0.5,
					   delay: 0.0,
					   usingSpringWithDamping: 1.0,
					   initialSpringVelocity: 0.3,
					   options: [],
					   animations: {
						self.container.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
		})

		dismissVC()
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}

}
