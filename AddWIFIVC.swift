//
//  AddWIFIVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class AddWIFIVC: UIViewController {

	private let tapToDismissGestureContainer = UIView()
	private let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
	private let modalView = UIView()
	private let titleLabel = UILabel()
	private let cancelButton = UIButton()
	private let textFieldStackView = UIStackView()
	private let nameStackView = UIStackView()
	private let wifiNameStackView = UIStackView()
	private let wifiPasswordStackView = UIStackView()
	private let bottomSafeAreaConstraint = NSLayoutConstraint()

	private let underline = UIView()
	private let saveButton = MiWiFiButton(backgroundColor: .miwifiButtonBGColor, tintColor: .systemBlue, textColor: .systemBlue, title: "Save", image: nil)
	private let nameTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "Name this entry", autocorrectionType: .yes, autocapitalizationType: .words)
	private let wifiNameTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "WiFi name", autocorrectionType: .no, autocapitalizationType: .none)
	private let passwordTextField = MiWiFiTextField(isSecureEntry: true, placeholder: "WiFi password", autocorrectionType: .no, autocapitalizationType: .none)

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .clear
		configureModalView()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
//		configureTapToDismissContainer()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIView.animate(withDuration: 0.5) {
			self.view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UIView.animate(withDuration: 0.1) {
			self.view.backgroundColor = .clear
		}
	}

//	private func configureTapGesture() {
//		tapToDismissGestureContainer.addGestureRecognizer(tapGesture)
//		tapGesture.numberOfTapsRequired = 1
//	}

//	private func configureTapToDismissContainer() {
//		view.addSubview(tapToDismissGestureContainer)
//		tapToDismissGestureContainer.backgroundColor = .clear
//
//		configureTapGesture()
//
//		tapToDismissGestureContainer.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			tapToDismissGestureContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//			tapToDismissGestureContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//			tapToDismissGestureContainer.bottomAnchor.constraint(equalTo: modalView.topAnchor, constant: 0),
//			tapToDismissGestureContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
//		])
//	}

	private func configureModalView() {
		view.addSubview(modalView)
		modalView.backgroundColor = .secondarySystemBackground
		modalView.layer.cornerRadius = 20
		modalView.layer.cornerCurve = .continuous

		modalView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			modalView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
			modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
		])

		configureTitleLabel()
		configureCancelButton()
		configureSaveButton()
		configureTextFieldStackView()
//		configureTextFields()
	}

	private func configureTitleLabel() {
		modalView.addSubview(titleLabel)
		titleLabel.textColor = .label
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		titleLabel.text = "Add WiFi"

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 25),
			titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor, constant: 0)
		])
	}

	private func configureCancelButton()  {
		modalView.addSubview(cancelButton)
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
		cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
		cancelButton.tintColor = .systemBlue
		NSLayoutConstraint.activate([
			cancelButton.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 20),
			cancelButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
			cancelButton.heightAnchor.constraint(equalToConstant: 30),
			cancelButton.widthAnchor.constraint(equalToConstant: 30)
		])
	}

	private func configureTextFieldStackView() {
		modalView.addSubview(textFieldStackView)
		textFieldStackView.translatesAutoresizingMaskIntoConstraints = false

		textFieldStackView.axis = .vertical
		textFieldStackView.alignment = .fill
		textFieldStackView.distribution = .fill
		textFieldStackView.spacing = 16

		underline.translatesAutoresizingMaskIntoConstraints = false
		underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
		underline.backgroundColor = .secondaryLabel

		[nameStackView, wifiNameStackView, wifiPasswordStackView].forEach {
			$0.axis = .vertical
			$0.alignment = .fill
			$0.distribution = .fill
			$0.spacing = 8
		}

		nameStackView.addArrangedSubview(nameTextField)
		wifiNameStackView.addArrangedSubview(wifiNameTextField)
		wifiPasswordStackView.addArrangedSubview(passwordTextField)

		[nameStackView, wifiNameStackView, wifiPasswordStackView].forEach { $0.addArrangedSubview(createUnderline()) }
		[nameStackView, wifiNameStackView, wifiPasswordStackView].forEach { textFieldStackView.addArrangedSubview($0) }

		let toBottomSafeArea = textFieldStackView.bottomAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.bottomAnchor)
		toBottomSafeArea.priority = .defaultHigh

		NSLayoutConstraint.activate([
			textFieldStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
			textFieldStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -50),
			textFieldStackView.bottomAnchor.constraint(lessThanOrEqualTo: saveButton.topAnchor, constant: -50),
			toBottomSafeArea,
			textFieldStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 50),
		])
	}

//	private func configureTextFields() {
//		[wifiNameTextField, passwordTextField].forEach { modalView.addSubview($0) }
//		[wifiNameTextField, passwordTextField].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
//
//		NSLayoutConstraint.activate([
//			wifiNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
//			wifiNameTextField.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -50),
//			wifiNameTextField.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 50),
//			wifiNameTextField.heightAnchor.constraint(equalToConstant: 50)
//		])
//
//		NSLayoutConstraint.activate([
//			passwordTextField.topAnchor.constraint(equalTo: wifiNameTextField.bottomAnchor, constant: 8),
//			passwordTextField.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -50),
//			passwordTextField.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 50),
//			passwordTextField.heightAnchor.constraint(equalToConstant: 50)
//		])
//	}

	private func configureSaveButton() {
		modalView.addSubview(saveButton)
		saveButton.translatesAutoresizingMaskIntoConstraints = false

		saveButton.layer.borderColor = UIColor.systemBlue.cgColor
		saveButton.layer.borderWidth = 1

		NSLayoutConstraint.activate([
			saveButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 50),
			saveButton.bottomAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			saveButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -50),
			saveButton.heightAnchor.constraint(equalToConstant: 40)
		])
	}

	private func createUnderline() -> UIView {
		let underline = UIView()
		underline.translatesAutoresizingMaskIntoConstraints = false
		underline.backgroundColor = .secondaryLabel
		underline.heightAnchor.constraint(equalToConstant: 1).isActive = true

		return underline
	}

	@objc private func tapToDismiss() {
		if tapGesture.state == .ended {
			dismiss(animated: true)
		}
	}

	@objc private func cancelButtonTapped() {
		dismiss(animated: true)
	}

	@objc func keyboardFrameWillChange(notification: NSNotification) {
		if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			let duration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? 0.2

			UIView.animate(withDuration: TimeInterval(truncating: duration)) {
				self.textFieldStackView.bottomAnchor
//				self.floatingViewBottomAnchor.constant = keyboardRect.height
				self.view.layoutSubviews()
			}
		}
	}
}
