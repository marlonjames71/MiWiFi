//
//  WIFIDetailVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/10/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import LocalAuthentication

class WIFIDetailVC: UIViewController {

	private let wifi: Wifi

	private var qrImageView: MiWiFiImageView
	private var infoView: WiFiInfoView

	init(with wifi: Wifi) {
		self.wifi = wifi
		self.qrImageView = MiWiFiImageView(with: wifi)
		self.infoView = WiFiInfoView(with: wifi)
		super.init(nibName: nil, bundle: nil)
	}


	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("Use init(with wifi: Wifi)")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavController()
		configureView()
		configureWifiInfoView()
	}


	private func configureView() {
		view.backgroundColor = .miBackground
		layoutAndConfigureImageView(imageView: qrImageView)
	}


	func configureNavController() {
		title = wifi.nickname
		let star = UIImage(systemName: "star.fill")?.withTintColor(.miFavoriteTint, renderingMode: .alwaysOriginal)
		let starImageView = UIImageView(image: star)

		if wifi.isFavorite {
			navigationItem.titleView = starImageView
		} else {
			navigationItem.titleView = nil
		}

		let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped(_:)))
		navigationItem.rightBarButtonItem = optionsButton
	}


	private func layoutAndConfigureImageView(imageView: UIImageView) {
		view.addSubview(imageView)
		imageView.isUserInteractionEnabled = true
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])

		let interaction = UIContextMenuInteraction(delegate: self)
		imageView.addInteraction(interaction)
	}


	private func configureWifiInfoView() {
		view.addSubview(infoView)
		NSLayoutConstraint.activate([
			infoView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 30),
			infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
		])
	}


	private func showAddWiFiScreen() {
		let addWifiVC = AddWIFIVC()
		let navController = UINavigationController(rootViewController: addWifiVC)
		addWifiVC.wifi = self.wifi
		addWifiVC.delegate = self
		addWifiVC.modalPresentationStyle = .automatic
		self.present(navController, animated: true)
	}


	private func makeContextMenu() -> UIMenu {
		let qrIcon = UIImage(systemName: "qrcode")?.withTintColor(.miGlobalTint, renderingMode: .alwaysOriginal)
		let viewIcon = UIImage(systemName: "doc.richtext")?.withTintColor(.miGlobalTint, renderingMode: .alwaysOriginal)

		let shareQR = UIAction(title: "QR Code Only", image: qrIcon, discoverabilityTitle: "Shares Only the QR Code", attributes: []) { _ in
			guard let image = self.qrImageView.image else { return }
			let source = ImageShareSource(image: image)
			self.share(image: source)
		}

		let shareView = UIAction(title: "QR Code & Network Info", image: viewIcon, discoverabilityTitle: "Shares QR Code & Info", attributes: []) { _ in
			guard let image = self.qrImageView.image else { return }
			let source = ImageShareSource(image: image, nickname: self.wifi.nickname, network: self.wifi.networkName, password: self.includePasswordIfIsRevealed())
			self.share(image: source)
		}

		let title = "*NOTE*\nPassword must be revealed first if you would like to include it in the snapshot."

		let shareMenu = UIMenu(title: "", image: nil, options: .displayInline, children: [shareQR, shareView])
		let menu = UIMenu(title: title, image: nil, children: [shareMenu])

		return menu
	}


	private func presentShareAndPrintAlert() {
		let title = "Choose how you want to print or share."
		let message = #"*NOTE*\#nIf you select "QR Code & Network Info" and want the password included in the snapshot, for security reasons, reveal the password first."#
		presentShareQRActionSheet(title: title,
								  message: message,
								  shareQRHandler: { _ in
									guard let qrImage = self.qrImageView.image else { return }
									let source = ImageShareSource(image: qrImage)
									self.share(image: source)
		}, shareViewHandler: { _ in
			guard let qrImage = self.qrImageView.image else { return }
			let source = ImageShareSource(image: qrImage, nickname: self.wifi.nickname, network: self.wifi.networkName, password: self.includePasswordIfIsRevealed())
			self.share(image: source)
		})
	}


	private func includePasswordIfIsRevealed() -> String? {
		let password = KeychainWrapper.standard.string(forKey: self.wifi.passwordIDStr)
		if infoView.isRevealed {
			return password
		} else {
			return ""
		}
	}


	private func requestAuth() {
		let context = LAContext()
		context.localizedFallbackTitle = "Please use your passcode"
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			let reason = "Authentication is required for you to continue"

			let biometricType = context.biometryType == .faceID ? "Face ID" : "Touch ID"
			print("Supported Biometric type is: \( biometricType )")

			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, authenticationError in
				guard let self = self else { return }
				DispatchQueue.main.async {
					if success {
						self.showAddWiFiScreen()
					} else {
						guard let error = error as? LAError else { return }
						NSLog(error.code.getErrorDescription())
						self.presentFailedVerificationWithFaceIDAlert()
					}
				}
			}
		} else {
			self.presentBiometryNotAvailableAlert()
		}
	}


	@objc private func optionsButtonTapped(_ sender: UIBarButtonItem) {
		let favoriteImage = UIImage(systemName: "star")!
		let unfavoriteImage = UIImage(systemName: "star.fill")!
			.withTintColor(.miFavoriteTint, renderingMode: .alwaysOriginal)
		let favStr = "Favorite"
		let unfavStr = "Unfavorite"

		let favoriteStr = wifi.isFavorite ? unfavStr : favStr
		let image = wifi.isFavorite ? unfavoriteImage : favoriteImage

		presentOptionsActionSheet(favoriteStr: favoriteStr, favoriteImage: image, deleteHandler: { delete in
			self.presentSecondaryDeleteAlertSingle(wifi: self.wifi, deleteHandler: { _ in
				guard let id = self.wifi.passwordID else { return }
				KeychainWrapper.standard.removeObject(forKey: id.uuidString)
				WifiController.shared.delete(wifi: self.wifi)
				self.navigationController?.popViewController(animated: true)
			})
		}, editHandler: { _ in
			if self.infoView.isRevealed {
				self.showAddWiFiScreen()
			} else {
				self.requestAuth()
			}
		}, favoriteHandler: { _ in
			WifiController.shared.updateFavorite(wifi: self.wifi, isFavorite: !self.wifi.isFavorite)
			self.qrImageView.layoutSubviews()
			self.infoView.configureView()
			self.configureNavController()
		}, shareAndPrintHandler: { _ in
			self.presentShareAndPrintAlert()
		})
	}
}


extension WIFIDetailVC: WiFiInfoViewDelegate {
	func showPasswordRequestedFailed() {
		self.presentFailedVerificationWithFaceIDAlert()
		print("Request Failed")
	}

	func biometricAuthenticationNotAvailable() {
		self.presentBiometryNotAvailableAlert()
	}
}

extension WIFIDetailVC: AddWiFiVCDelegate {
	func didFinishUpdating() {
		qrImageView.removeFromSuperview()
		infoView.removeFromSuperview()

		self.qrImageView = MiWiFiImageView(with: wifi)
		self.infoView = WiFiInfoView(with: wifi)

		configureNavController()
		configureView()
		configureWifiInfoView()
	}
}


extension WIFIDetailVC: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
			return self.makeContextMenu()
		}
	}
}
