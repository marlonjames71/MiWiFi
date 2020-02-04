//
//  WIFIDetailVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/10/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

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
		view.backgroundColor = .miBlueGreyBG
		layoutAndConfigureImageView(imageView: qrImageView)
	}


	func configureNavController() {
		title = wifi.nickname
		let star = UIImage(systemName: "star.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
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
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])

		let interaction = UIContextMenuInteraction(delegate: self)
		imageView.addInteraction(interaction)
		imageView.isUserInteractionEnabled = true
	}


	private func configureWifiInfoView() {
		view.addSubview(infoView)
		NSLayoutConstraint.activate([
			infoView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 30),
			infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
		])
	}

	private func makeContextMenu() -> UIMenu {
		let qrIcon = UIImage(systemName: "qrcode")?.withTintColor(.miNeonYellowGreen, renderingMode: .alwaysOriginal)
		let viewIcon = UIImage(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")?.withTintColor(.miNeonYellowGreen, renderingMode: .alwaysOriginal)

		let shareQR = UIAction(title: "QR Code Only", image: qrIcon, discoverabilityTitle: "Shares Only the QR Code", attributes: []) { _ in
			let image = self.qrImageView.screenshot()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
				self.share(image: image)
			})
		}

		let shareView = UIAction(title: "QR Code & Network Info", image: viewIcon, discoverabilityTitle: "Shares QR Code & Info", attributes: []) { _ in
			let image = self.view.screenshot()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
				self.share(image: image)
			})
		}

		let shareMenu = UIMenu(title: "", image: nil, options: .displayInline, children: [shareQR, shareView])
		let menu = UIMenu(title: "Share or Print", image: nil, children: [shareMenu])

		return menu
	}


	private func presentShareAndPrintAlert() {
		let title = "Choose how you want to print or share."
		let message = "You can print or share just the QR code, or the QR code and network information."
		presentShareQRActionSheet(title: title,
								  message: message,
								  shareQRHandler: { _ in
									let qrImage = self.qrImageView.screenshot()
									self.share(image: qrImage)
		}, shareViewHandler: { _ in
			let viewImage = self.view.screenshot()
			self.share(image: viewImage)
		})
	}


	@objc private func optionsButtonTapped(_ sender: UIBarButtonItem) {
		let favoriteImage = UIImage(systemName: "star")!
		let unfavoriteImage = UIImage(systemName: "star.fill")!
			.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
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
		}, editHandler: { edit in
			let addWifiVC = AddWIFIVC()
			let navController = UINavigationController(rootViewController: addWifiVC)
			addWifiVC.wifi = self.wifi
			addWifiVC.delegate = self
			addWifiVC.modalPresentationStyle = .automatic
			self.present(navController, animated: true)
		}, favoriteHandler: { favorite in
			WifiController.shared.updateFavorite(wifi: self.wifi, isFavorite: !self.wifi.isFavorite)
			self.configureNavController()
		}, shareAndPrintHandler: { shareAndPrint in
			self.presentShareAndPrintAlert()
		})
	}
}


extension WIFIDetailVC: WiFiInfoViewDelegate {
	func showPasswordRequestedFailed() {
		Alerts.presentFailedVerificationWithFaceIDAlert(on: self)
		print("Request Failed")
	}

	func biometricAuthenticationNotAvailable() {
		Alerts.presentBiometryNotAvailableAlert(on: self)
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
