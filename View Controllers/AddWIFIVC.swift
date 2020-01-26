//
//  AddWIFIVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol AddWiFiVCDelegate: AnyObject {
	func didFinishSaving()
}

class AddWIFIVC: UIViewController {

	enum IconName: String {
		case home = "house.fill"
		case work = "briefcase.fill"
		case misc = "wifi"
	}

	private let tapToDismissGestureContainer = UIView()
	private let modalView = UIView()
	private let titleLabel = UILabel()
	private let saveButton = UIButton(type: .system)
	private let dismissButton = UIButton(type: .system)
	private let mainStackView = UIStackView()
	private let elementStackView = UIStackView()
	private let buttonStackView = UIStackView()
	private let bottomSafeAreaConstraint = NSLayoutConstraint()
	private let iconSegControl = UISegmentedControl()
	private let iconImageView = UIImageView()

	private let nameTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "Name this entry", autocorrectionType: .yes, autocapitalizationType: .words)
	private let wifiNameTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "WiFi name", autocorrectionType: .no, autocapitalizationType: .none)
	private let passwordTextField = MiWiFiTextField(isSecureEntry: true, placeholder: "WiFi password", autocorrectionType: .no, autocapitalizationType: .none)

	lazy var bottomConstraint = dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70)

	weak var delegate: AddWiFiVCDelegate?

	var wifiController: WifiController?

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	var icon: IconName = .home
	var desc: String = "Home"

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .clear

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

		configureFXView()
		configureTitleLabel()
		configureIconImageView()
		configureSaveButton()
		configureSegControl()
		configureElementStackView()
		configureDismissButton()

		nameTextField.becomeFirstResponder()
    }

	deinit {
		print("deinit")
	}

	private func configureFXView() {
		let blurEffect = UIBlurEffect(style: .regular)
		let blurredEffectView = UIVisualEffectView(effect: blurEffect)
		blurredEffectView.frame = view.bounds

		let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
		let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)

		[titleLabel,
		 iconImageView,
		 iconSegControl,
		 saveButton,
		 nameTextField,
		 wifiNameTextField,
		 passwordTextField,
		 dismissButton].forEach { vibrancyEffectView.contentView.addSubview($0) }

		blurredEffectView.contentView.addSubview(vibrancyEffectView)
		view.addSubview(blurredEffectView)
	}

	private func configureTitleLabel() {
		view.addSubview(titleLabel)
		titleLabel.textColor = .label
		titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		titleLabel.text = "Add WiFi"

		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
		])
	}

	private func configureSaveButton()  {
		view.addSubview(saveButton)
		saveButton.translatesAutoresizingMaskIntoConstraints = false
		saveButton.addTarget(self, action: #selector(saveTapped(_:)), for: .touchUpInside)
		let title = NSAttributedString(string: "Save", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .medium)])
		saveButton.setAttributedTitle(title, for: .normal)
		saveButton.tintColor = .miTintColor

		dismissButton.setTitle("Dismiss", for: .normal)
		dismissButton.setTitleColor(.label, for: .normal)
		dismissButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)

		NSLayoutConstraint.activate([
			saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
		])
	}

	private func configureIconImageView() {
		view.addSubview(iconImageView)
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.tintColor = .miTintColor
		iconImageView.contentMode = .center
		let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
		iconImageView.image = UIImage(systemName: "house.fill", withConfiguration: configuration)

		NSLayoutConstraint.activate([
			iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			iconImageView.heightAnchor.constraint(equalToConstant: 30),
			iconImageView.widthAnchor.constraint(equalToConstant: 30)
		])
	}

	private func configureElementStackView() {
		view.addSubview(elementStackView)
		elementStackView.translatesAutoresizingMaskIntoConstraints = false

		elementStackView.axis = .vertical
		elementStackView.alignment = .fill
		elementStackView.distribution = .fill
		elementStackView.spacing = 30

		[nameTextField, wifiNameTextField, passwordTextField].forEach {
			$0.heightAnchor.constraint(equalToConstant: 40).isActive = true
			$0.delegate = self
		}

		[iconSegControl,
		 nameTextField,
		 wifiNameTextField,
		 passwordTextField].forEach { elementStackView.addArrangedSubview($0) }

		NSLayoutConstraint.activate([
			elementStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
			elementStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			elementStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//			elementStackView.bottomAnchor.constraint(equalTo: modalView.safeAreaLayoutGuide.bottomAnchor, constant: -50),
		])
	}

	private func configureDismissButton() {
		view.addSubview(dismissButton)
		dismissButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			dismissButton.heightAnchor.constraint(equalToConstant: 30),
			bottomConstraint
		])
	}

	private func configureSegControl() {
		view.addSubview(iconSegControl)
		iconSegControl.translatesAutoresizingMaskIntoConstraints = false
		iconSegControl.sizeToFit()

		iconSegControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
		iconSegControl.selectedSegmentTintColor = .miTintColor
		iconSegControl.backgroundColor = .miBackground
		iconSegControl.tintColor = .miTintColor

		iconSegControl.insertSegment(withTitle: "Home", at: 0, animated: true)
		iconSegControl.insertSegment(withTitle: "Work", at: 1, animated: true)
		iconSegControl.insertSegment(withTitle: "Misc", at: 2, animated: true)

		iconSegControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

		iconSegControl.selectedSegmentIndex = 0
		iconSegControl.addTarget(self, action: #selector(segControlDidChange), for: .valueChanged)
	}

	private func updateViews() {
		guard let wifi = wifi else { return }
		nameTextField.text = wifi.name
		wifiNameTextField.text = wifi.wifiName
		passwordTextField.text = wifi.password
	}

	@objc private func saveTapped(_ sender: UIButton) {
		guard let controller = wifiController else { return }
		guard let name = nameTextField.text,
			let wifiName = wifiNameTextField.text,
			let wifiPassword = passwordTextField.text else { return }

		controller.addWifi(name: name, wifiName: wifiName, password: wifiPassword, locationDesc: desc, iconName: icon.rawValue)
		delegate?.didFinishSaving()
		dismiss(animated: true)
	}

	@objc private func cancelButtonTapped() {
		navigationController?.popViewController(animated: true)
		dismiss(animated: true)
	}

	@objc private func segControlDidChange() {
		let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
		switch iconSegControl.selectedSegmentIndex {
		case 0:
			iconImageView.image = UIImage(systemName: "house.fill", withConfiguration: configuration)
			icon = .home
			desc = "Home"
		case 1:
			iconImageView.image = UIImage(systemName: "briefcase.fill", withConfiguration: configuration)
			icon = .work
			desc = "Work"
		case 2:
			iconImageView.image = UIImage(systemName: "wifi", withConfiguration: configuration)
			icon = .misc
			desc = "Misc"
		default:
			break
		}
	}

	@objc func keyboardFrameWillChange(notification: NSNotification) {
			if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
				let duration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? 0.2

				UIView.animate(withDuration: TimeInterval(truncating: duration)) {
					self.bottomConstraint.constant = -(keyboardRect.height + 8)
					self.view.layoutSubviews()
				}
			}
		}

	@objc func keyboardWillHide(notification: NSNotification) {
			let duration: NSNumber = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber ?? 0.2

			UIView.animate(withDuration: TimeInterval(truncating: duration)) {
				self.bottomConstraint.constant = -70
				self.view.layoutSubviews()
			}
		}
}

extension AddWIFIVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	}
}
