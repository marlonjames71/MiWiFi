//
//  ISPInputView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/15/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

protocol ISPInputViewDelegate: class {
	func dismissView()
}

protocol ISPInputViewSaveDelegate: class {
	func didTapSave()
}

class ISPInputView: UIView {

	// MARK: - Properties
	private let wifi: Wifi

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
		button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
		button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		return button
	}()

	private let saveButton = MiWiFiSaveButton()

	weak var delegate: ISPInputViewDelegate?
	weak var saveDelegate: ISPInputViewSaveDelegate?


	// MARK: - Init
	init(frame: CGRect = .zero, with wifi: Wifi) {
		self.wifi = wifi
		super.init(frame: frame)
		nameTextField.textField.becomeFirstResponder()
		configure()
		configureTextFields()
		configureStackView()
	}

	override init(frame: CGRect) {
		fatalError("Use init(frame with wifi")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Configure Methods
	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .miContainerBackground
		layer.cornerRadius = 16
		layer.cornerCurve = .continuous
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
		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

		views.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			$0.heightAnchor.constraint(equalToConstant: 45).isActive = true
		}

		let vertStackView = UIStackView.fillStackView(axis: .vertical, spacing: 30, with: views)
		vertStackView.addArrangedSubview(saveButton)
		self.addSubview(vertStackView)
		vertStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			vertStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
			vertStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
			vertStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
			vertStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
		])
	}


	// MARK: - Actions
	@objc private func dismissButtonTapped() {
		delegate?.dismissView()
	}


	@objc private func saveButtonTapped() {
		guard let name = nameTextField.textField.text else { return }
		let isp = ISPController.shared.createISP(name: name, urlString: urlTextField.textField.text, phone: phoneTextField.textField.text)
		WifiController.shared.updateISP(wifi: wifi, isp: isp)
		delegate?.dismissView()
		saveDelegate?.didTapSave()
	}
}

extension ISPInputView: UITextFieldDelegate {
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
