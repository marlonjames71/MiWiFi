//
//  Alerts.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

struct Alerts {
	static func showOptionsActionSheetForTableVC(vc: WiFiTableVC, wifi: Wifi, wifiController: WifiController) {
		let titleStr = """
		Print or Share wifi
		Nickname: \(wifi.nickname ?? "")
		Network: \(wifi.networkName ?? "")
		"""
		let actionSheet = UIAlertController(title: titleStr, message: nil, preferredStyle: .actionSheet)

		let printAction = UIAlertAction(title: "Print", style: .default) { (action) in
			// code goes here
		}
		printAction.setValue(UIImage(systemName: "printer.fill"), forKey: "image")

		let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
			// code goes here
		}
		shareAction.setValue(UIImage(systemName: "square.and.arrow.up.fill"), forKey: "image")

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)


		[printAction, shareAction, cancelAction].forEach { actionSheet.addAction($0) }
		vc.present(actionSheet, animated: true)
	}


	static func showOptionsActionSheetForDetailVC(vc: WIFIDetailVC, wifi: Wifi, wifiController: WifiController) {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let deletAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
			presentSecondaryDeletePromptOnDetailVC(vc: vc, wifi: wifi, wifiController: wifiController)
		}

		let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
			let addWifiVC = AddWIFIVC()
			addWifiVC.wifi = wifi
			addWifiVC.wifiController = wifiController
			addWifiVC.modalPresentationStyle = .overFullScreen
			vc.present(addWifiVC, animated: true)
		}
//		editAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		editAction.setValue(UIImage(systemName: "square.and.pencil"), forKey: "image")

		let favoriteImage = UIImage(systemName: "star")
		let unfavoriteImage = UIImage(systemName: "star.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
		let favoriteStr = "Favorite"
		let unfavoriteStr = "Unfavorite"

		let title = wifi.isFavorite ? unfavoriteStr : favoriteStr
		let image = wifi.isFavorite ? unfavoriteImage : favoriteImage

		let favoriteAction = UIAlertAction(title: title, style: .default) { _ in
			guard let id = wifi.passwordID else { return }
			wifiController.updateWifi(wifi: wifi,
									  nickname: wifi.nickname ?? "",
									  networkName: wifi.networkName ?? "",
									  passwordID: id,
									  locationDesc: wifi.locationDesc ?? "",
									  iconName: wifi.iconName ?? "home.fill",
									  isFavorite: !wifi.isFavorite)
			vc.configureNavController()
		}
		favoriteAction.setValue(image, forKey: "image")

		let printAction = UIAlertAction(title: "Print", style: .default) { (action) in
			// code goes here
		}
//		printAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		printAction.setValue(UIImage(systemName: "printer.fill"), forKey: "image")

		let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
			// code goes here
		}
//		shareAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		shareAction.setValue(UIImage(systemName: "square.and.arrow.up.fill"), forKey: "image")

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		[deletAction, printAction, shareAction, favoriteAction, editAction, cancelAction].forEach { actionSheet.addAction($0) }
		vc.present(actionSheet, animated: true)
	}

	static func presentSecondaryDeletePromptOnDetailVC(vc: WIFIDetailVC, wifi: Wifi, wifiController: WifiController) {
		let deletStr = "Are you sure you want to delete \(wifi.nickname ?? "")?"
		let actionSheet = UIAlertController(title: deletStr, message: nil, preferredStyle: .actionSheet)

		let deletAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
			guard let id = wifi.passwordID else { return }
			KeychainWrapper.standard.removeObject(forKey: id.uuidString)
			wifiController.delete(wifi: wifi)
			vc.navigationController?.popViewController(animated: true)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

		[deletAction, cancelAction].forEach { actionSheet.addAction($0) }
		vc.present(actionSheet, animated: true)
	}

	static func presentSecondaryDeletePromptOnTableVC(vc: WiFiTableVC, wifi: Wifi, wifiController: WifiController) {
		let deletStr = "Are you sure you want to delete \(wifi.nickname ?? "")?"
		let actionSheet = UIAlertController(title: deletStr, message: nil, preferredStyle: .actionSheet)

		let deletAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
			guard let id = wifi.passwordID else { return }
			KeychainWrapper.standard.removeObject(forKey: id.uuidString)
			wifiController.delete(wifi: wifi)
		}

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

		[deletAction, cancelAction].forEach { actionSheet.addAction($0) }
		vc.present(actionSheet, animated: true)
	}

	static func presentFailedVerificationWithFaceIDAlert(on vc: WIFIDetailVC) {
		let alertController = UIAlertController(title: "Verification Failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		vc.present(alertController, animated: true)
	}

	static func presentBiometryNotAvailableAlert(on vc: WIFIDetailVC) {
		let alertController = UIAlertController(title: "Biometry Failed", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		vc.present(alertController, animated: true)
	}
}

extension UIAlertController {
	override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		self.view.tintColor = .miTintColor
    }
}
