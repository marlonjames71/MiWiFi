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
	private let haptic = UIImpactFeedbackGenerator(style: .medium)

	private let saveButton = MiWiFiBarButton(backgroundColor: UIColor.miGlobalTint.withAlphaComponent(0.1),
									 tintColor: .miGlobalTint,
									 textColor: .miGlobalTint,
									 title: "Save",
									 imageStr: nil)

	private let nameTextField = MiWiFiTextFieldView(isSecureEntry: false,
													placeholder: "Name of ISP",
													autocorrectionType: .no,
													autocapitalizationType: .words,
													returnType: .continue)

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
		button.addTarget(self, action: #selector(containerAnimateOut), for: .touchUpInside)
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return button
	}()


	// MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureContainerView()
		configureTextFields()
		configureStackView()
		haptic.prepare()
    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		containerAnimateIn()
	}


	private func configureView() {
		view.backgroundColor = .clear

		let blur = UIBlurEffect(style: .regular)
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
			container.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
		])

		container.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
	}


	private func configureTextFields() {
		nameTextField.textField.becomeFirstResponder()
		nameTextField.textField.placeholder = "e.g. CenturyLink"
		urlTextField.textField.placeholder = "e.g. https://wesite.com"
		urlTextField.textField.keyboardType = .URL
		phoneTextField.textField.placeholder = "e.g. 8005557171"
		phoneTextField.textField.keyboardType = .numbersAndPunctuation
		[nameTextField, urlTextField, phoneTextField].forEach {
			$0.textField.delegate = self
		}
	}


	private func configureStackView() {
		let horizStackView = UIStackView(arrangedSubviews: [titleLabel, dismissButton])
		horizStackView.axis = .horizontal
		horizStackView.distribution = .fill
		horizStackView.spacing = 8


		let views: [UIView] = [horizStackView, nameTextField, urlTextField, phoneTextField]
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


	@objc private func containerAnimateIn() {
		guard container.transform != .identity else { return }
		UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
			self.container.transform = .identity
		}, completion: { _ in
			self.haptic.impactOccurred()
		})
	}


	@objc private func containerAnimateOut() {
		UIView.animate(withDuration: 0.2, animations: {
			self.container.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
		})

		self.dismissVC()
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}
}


extension AddISPVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case nameTextField.textField:
			urlTextField.textField.becomeFirstResponder()
		case urlTextField.textField:
			phoneTextField.textField.becomeFirstResponder()
		case phoneTextField.textField:
			phoneTextField.textField.resignFirstResponder()
		default:
			textField.resignFirstResponder()

		}
		return false
	}
}
