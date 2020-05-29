//
//  AddWIFIVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol AddWiFiVCDelegate: AnyObject {
	func didFinishUpdating()
}

class AddWIFIVC: UIViewController {

	enum IconInfo: String {
		case home = "Home"
		case homeIconName = "house.fill"
		case work = "Work"
		case workIconName = "briefcase.fill"
		case misc = "Misc"
		case miscIconName = "wifi"

		var homeImage: UIImage {
			return UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
		}

		var workImage: UIImage {
			return UIImage(systemName: "briefcase.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
		}

		var miscImage: UIImage {
			return UIImage(systemName: "wifi", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
		}
	}


	private let tapToDismissGestureContainer = UIView()
	private let modalView = UIView()
	private let mainStackView = UIStackView()
	private let elementStackView = UIStackView()
	private let buttonStackView = UIStackView()
	private let bottomSafeAreaConstraint = NSLayoutConstraint()
	private let iconSegControl = UISegmentedControl()

	private let iconButton = UIButton()
	private let configuration = UIImage.SymbolConfiguration(pointSize: 25)
	private let largeGrayWifiIcon = MiWiFiEmptyStateView(message: "")

	private let nicknameTextField = MiWiFiTextFieldView(isSecureEntry: false, placeholder: "Nickname", autocorrectionType: .no, autocapitalizationType: .words, returnType: .continue, needsRevealButton: false)
	private let networkTextField = MiWiFiTextFieldView(isSecureEntry: false, placeholder: "Network", autocorrectionType: .no, autocapitalizationType: .none, returnType: .continue, needsRevealButton: false)
	private let passwordTextField = MiWiFiTextFieldView(isSecureEntry: true, placeholder: "Password", autocorrectionType: .no, autocapitalizationType: .none, returnType: .done, needsRevealButton: true)

	private let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(_:)))

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	var icon: IconInfo = .homeIconName
	var desc: String = "Home"

	weak var delegate: AddWiFiVCDelegate?


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .miSecondaryBackground
		navigationController?.presentationController?.delegate = self
		isModalInPresentation = false
		

		configureLargeWifiIcon()
		configureNavBar()
		configureSegControl()
		configureElementStackView()
		updateViews()
		configureTapGestureForView()

		nicknameTextField.textField.becomeFirstResponder()
    }


	private func updateViews() {
		guard let wifi = wifi else { return }
		title = wifi.nickname
		nicknameTextField.textField.text = wifi.nickname
		networkTextField.textField.text = wifi.networkName
		passwordTextField.textField.text = KeychainWrapper.standard.string(forKey: wifi.passwordID?.uuidString ?? "No Password")

		if wifi.iconName == IconInfo.homeIconName.rawValue {
			iconSegControl.selectedSegmentIndex = 0
			iconButton.setImage(IconInfo.home.homeImage, for: .normal)
		} else if wifi.iconName == IconInfo.workIconName.rawValue {
			iconSegControl.selectedSegmentIndex = 1
			iconButton.setImage(IconInfo.work.workImage, for: .normal)
		} else if wifi.iconName == IconInfo.miscIconName.rawValue {
			iconSegControl.selectedSegmentIndex = 2
			iconButton.setImage(IconInfo.misc.miscImage, for: .normal)
		}
	}


	deinit {
		print("deinit")
	}


	// MARK: - Configuration
	private func configureLargeWifiIcon() {
		view.addSubview(largeGrayWifiIcon)
		largeGrayWifiIcon.frame = view.bounds
	}


	private func configureTapGestureForView() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewToDismissKeyboard(_:)))
		tapGesture.numberOfTapsRequired = 1
		view.addGestureRecognizer(tapGesture)
	}


	private func configureNavBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.barTintColor = .clear
		navigationController?.navigationBar.tintColor = .miGlobalTint

		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]

		if wifi == nil {
			title = "Add WiFi"
		}

		let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
		navigationItem.rightBarButtonItem = saveBarButtonItem
		// ↓ ↓ ↓ Removing this line breaks the save button after resignFirstResponder() ⤸ ⤸ ⤸
		saveBarButtonItem.target = self
		saveBarButtonItem.isEnabled = false
		navigationItem.leftBarButtonItem = cancelBarButton
		iconButton.setImage(IconInfo.home.homeImage, for: .normal)
		iconButton.tintColor = .miIconTint
		navigationItem.titleView = iconButton
	}


	private func configureElementStackView() {
		view.addSubview(elementStackView)
		elementStackView.translatesAutoresizingMaskIntoConstraints = false

		elementStackView.axis = .vertical
		elementStackView.alignment = .fill
		elementStackView.distribution = .fill

		if UIScreen.main.bounds.height <= 667 {
			elementStackView.spacing = 25
			[nicknameTextField, networkTextField, passwordTextField].forEach {
				$0.heightAnchor.constraint(equalToConstant: 40).isActive = true
			}
		} else {
			elementStackView.spacing = 30
			[nicknameTextField, networkTextField, passwordTextField].forEach {
				$0.heightAnchor.constraint(equalToConstant: 50).isActive = true
			}
		}

		[nicknameTextField.textField, networkTextField.textField, passwordTextField.textField].forEach { $0.delegate = self }

		nicknameTextField.textField.addTarget(self, action: #selector(updateTitleWhileEditing(_:)), for: .editingChanged)
		[nicknameTextField.textField, networkTextField.textField, passwordTextField.textField].forEach {
			$0.addTarget(self, action: #selector(watchChangesOccurred(_:)), for: .editingChanged)
		}

		[iconSegControl,
		 nicknameTextField,
		 networkTextField,
		 passwordTextField].forEach { elementStackView.addArrangedSubview($0) }

		nicknameTextField.textField.placeholder = "e.g., Home, Office..."

		NSLayoutConstraint.activate([
			elementStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			elementStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			elementStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
		])
	}


	private func configureSegControl() {
		view.addSubview(iconSegControl)
		iconSegControl.translatesAutoresizingMaskIntoConstraints = false
		iconSegControl.sizeToFit()

		iconSegControl.setTitleTextAttributes([.foregroundColor : UIColor.segSelectedTextColor], for: .selected)
		iconSegControl.selectedSegmentTintColor = .miGlobalTint
		iconSegControl.backgroundColor = .miGrayColor
		iconSegControl.tintColor = .miGlobalTint

		iconSegControl.insertSegment(withTitle: IconInfo.home.rawValue, at: 0, animated: true)
		iconSegControl.insertSegment(withTitle: IconInfo.work.rawValue, at: 1, animated: true)
		iconSegControl.insertSegment(withTitle: IconInfo.misc.rawValue, at: 2, animated: true)

		iconSegControl.heightAnchor.constraint(equalToConstant: 30).isActive = true

		if wifi == nil {
			iconSegControl.selectedSegmentIndex = 0
		}

		iconSegControl.addTarget(self, action: #selector(segControlDidChange), for: .valueChanged)
	}


	// MARK: - Actions & Methods
	@objc private func tapViewToDismissKeyboard(_ sender: UITapGestureRecognizer) {
		[nicknameTextField.textField, networkTextField.textField, passwordTextField.textField].forEach { $0.resignFirstResponder() }
	}


	private func updateWifi(wifi: Wifi) {
		if let nickname = nicknameTextField.textField.text,
			let networkName = networkTextField.textField.text,
			let id = wifi.passwordID,
			!nickname.isEmpty,
			!networkName.isEmpty {

			WifiController.shared.updateWifi(wifi: wifi,
								  nickname: nickname,
								  networkName: networkName,
								  passwordID: id,
								  locationDesc: desc,
								  iconName: icon.rawValue,
								  isFavorite: wifi.isFavorite)
			
			savePasswordToKeychain(id: id)
			delegate?.didFinishUpdating()
			dismiss(animated: true)
		}
	}


	func saveWifi() {
		if let wifi = wifi {
			updateWifi(wifi: wifi)
			return
		}

		let id = UUID()
		guard let nickname = nicknameTextField.textField.text, !nickname.isEmpty,
			let networkName = networkTextField.textField.text, !networkName.isEmpty else { return }

		savePasswordToKeychain(id: id)

		WifiController.shared.addWifi(nickname: nickname, networkName: networkName, passwordID: id, locationDesc: desc, iconName: icon.rawValue)
		dismiss(animated: true)
	}


	@objc private func saveTapped(_ sender: UIBarButtonItem) {
		saveWifi()
	}


	private func savePasswordToKeychain(id: UUID) {
		if let password = passwordTextField.textField.text,
			!password.isEmpty {
			KeychainWrapper.standard.set(password, forKey: id.uuidString)
		} else {
			KeychainWrapper.standard.set("", forKey: id.uuidString)
		}
	}


	@objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
	}


	@objc private func watchChangesOccurred(_ sender: UITextField) {
		let saveButtonEnabled = nicknameTextField.textField.text?.isEmpty != true && networkTextField.textField.text?.isEmpty != true

		saveBarButtonItem.isEnabled = saveButtonEnabled
		isModalInPresentation = saveButtonEnabled
	}


	@objc private func updateTitleWhileEditing(_ sender: UITextField) {
		guard let text = nicknameTextField.textField.text else { return  }

		if let wifi = wifi {
			title = text != "" ? text : wifi.nickname
			if text == "" {
				navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miGrayColor,
				.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
			} else {
				navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label,
				.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
			}
		} else {
			title = text != "" ? text : "Add WiFi"
		}
	}


	@objc private func segControlDidChange() {
		switch iconSegControl.selectedSegmentIndex {
		case 0:
			iconButton.setImage(IconInfo.home.homeImage, for: .normal)
			icon = .homeIconName
			desc = IconInfo.home.rawValue
		case 1:
			iconButton.setImage(IconInfo.work.workImage, for: .normal)
			icon = .workIconName
			desc = IconInfo.work.rawValue
		case 2:
			iconButton.setImage(IconInfo.misc.miscImage, for: .normal)
			icon = .miscIconName
			desc = IconInfo.misc.rawValue
		default:
			break
		}

		if wifi != nil {
			saveBarButtonItem.isEnabled = wifi?.iconName != icon.rawValue
		}

		isModalInPresentation = saveBarButtonItem.isEnabled
	}
}

extension AddWIFIVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case passwordTextField.textField:
			saveWifi()
			passwordTextField.textField.resignFirstResponder()
		case nicknameTextField.textField:
			networkTextField.textField.becomeFirstResponder()
		case networkTextField.textField:
			passwordTextField.textField.becomeFirstResponder()
		default:
			textField.resignFirstResponder()
		}

		return false
	}
}


extension AddWIFIVC: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		presentAttemptToDismissActionSheet(saveHandler: { _ in
			self.saveWifi()
			self.dismiss(animated: true)
		}, discardHandler: { _ in
			self.dismiss(animated: true)
		})
	}
}
