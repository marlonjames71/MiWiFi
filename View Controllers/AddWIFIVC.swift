//
//  AddWIFIVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

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

	private let nicknameTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "Nickname", autocorrectionType: .yes, autocapitalizationType: .words)
	private let networkTextField = MiWiFiTextField(isSecureEntry: false, placeholder: "Network", autocorrectionType: .no, autocapitalizationType: .none)
	private let passwordTextField = MiWiFiTextField(isSecureEntry: true, placeholder: "Password", autocorrectionType: .no, autocapitalizationType: .none)

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	var icon: IconInfo = .homeIconName
	var desc: String = "Home"


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .miBlueGreyBG
		navigationController?.presentationController?.delegate = self

		

		configureLargeWifiIcon()
		configureNavBar()
		configureSegControl()
		configureElementStackView()
		updateViews()
		configureTapGestureForView()

		nicknameTextField.becomeFirstResponder()
    }


	private func updateViews() {
		guard let wifi = wifi else { return }
		title = wifi.nickname
		nicknameTextField.text = wifi.nickname
		networkTextField.text = wifi.networkName
		passwordTextField.text = KeychainWrapper.standard.string(forKey: wifi.passwordID?.uuidString ?? "No Password")

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


	// MARK: - Configuartion
	private func configureLargeWifiIcon() {
		view.addSubview(largeGrayWifiIcon)
		largeGrayWifiIcon.frame = view.bounds
	}


	private func configureTapGestureForView() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapViewToDimissKeyboard(_:)))
		tapGesture.numberOfTapsRequired = 1
		view.addGestureRecognizer(tapGesture)
	}


	private func configureNavBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.barTintColor = .clear
		navigationController?.navigationBar.tintColor = .miNeonYellowGreen

		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label,
		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]

		if wifi == nil {
			title = "Add WiFi"
		}

		let cancelBarbutton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped(_:)))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(_:)))
		navigationItem.leftBarButtonItem = cancelBarbutton
		iconButton.setImage(IconInfo.home.homeImage, for: .normal)
		iconButton.tintColor = .miNeonTeal
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

		[nicknameTextField, networkTextField, passwordTextField].forEach { $0.delegate = self }

		nicknameTextField.addTarget(self, action: #selector(updateTitleWhileEditing(_:)), for: .editingChanged)

		[iconSegControl,
		 nicknameTextField,
		 networkTextField,
		 passwordTextField].forEach { elementStackView.addArrangedSubview($0) }

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

		iconSegControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
		iconSegControl.selectedSegmentTintColor = .miDarkTeal
		iconSegControl.backgroundColor = .miBlueGreyBG
		iconSegControl.tintColor = .miDarkTeal

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
	@objc private func tapViewToDimissKeyboard(_ sender: UITapGestureRecognizer) {
		[nicknameTextField, networkTextField, passwordTextField].forEach { $0.resignFirstResponder() }
	}

	#warning("Start here!")
	@objc private func watchChangesOccured() {
		if wifi == nil {
			[nicknameTextField, networkTextField, passwordTextField].forEach {
				if $0.text == "" {
					isModalInPresentation = false
				} else {
					isModalInPresentation = true
				}
			}
		} else if wifi != nil {
			let wifiPassword = KeychainWrapper.standard.string(forKey: wifi?.passwordID?.uuidString ?? "")
			if wifi?.nickname != nicknameTextField.text ||
				wifi?.networkName != networkTextField.text ||
				wifiPassword != passwordTextField.text {
				isModalInPresentation = true
			} else {
				isModalInPresentation = false
			}
		}
	}


	private func updateWifi(wifi: Wifi) {
		if let nickname = nicknameTextField.text,
			let networkname = networkTextField.text,
			let id = wifi.passwordID,
			!nickname.isEmpty,
			!networkname.isEmpty {

			WifiController.shared.updateWifi(wifi: wifi,
								  nickname: nickname,
								  networkName: networkname,
								  passwordID: id,
								  locationDesc: desc,
								  iconName: icon.rawValue,
								  isFavorite: wifi.isFavorite)
			
			savePasswordToKeychain(id: id)
			dismiss(animated: true)
		}
	}


	func saveWifi() {
		if let wifi = wifi {
			updateWifi(wifi: wifi)
			return
		}

		let id = UUID()
		guard let name = nicknameTextField.text,
			let wifiName = networkTextField.text else { return }

		savePasswordToKeychain(id: id)

		WifiController.shared.addWifi(nickname: name, networkName: wifiName, passwordID: id, locationDesc: desc, iconName: icon.rawValue)
	}


	@objc private func updateTitleWhileEditing(_ sender: UITextField) {
		guard let text = nicknameTextField.text else { return  }

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


	@objc private func saveTapped(_ sender: UIBarButtonItem) {
		saveWifi()
		dismiss(animated: true)
	}


	private func savePasswordToKeychain(id: UUID) {
		if let password = passwordTextField.text,
			!password.isEmpty {
			KeychainWrapper.standard.set(password, forKey: id.uuidString)
		} else {
			KeychainWrapper.standard.set("", forKey: id.uuidString)
		}
	}


	@objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
		dismiss(animated: true)
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
	}
}

extension AddWIFIVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
	}
}


extension AddWIFIVC: UIAdaptivePresentationControllerDelegate {
	func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		watchChangesOccured()
		presentAttemptTodismissActionSheet(saveHandler: { _ in
			self.saveWifi()
			self.dismiss(animated: true)
		}, discardHandler: { _ in
			self.dismiss(animated: true)
		})
	}
}
