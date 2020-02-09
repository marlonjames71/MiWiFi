//
//  UIViewController+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/28/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func showEmptyStateView(with message: String, in view: UIView) {
		let emptyStateView = MiWiFiEmptyStateView(message: message)
		emptyStateView.frame = view.bounds
		view.addSubview(emptyStateView)
	}


	func share(image: UIImage) {
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: [])
		present(activityController, animated: true)
	}


	// MARK: - Alerts
	/// Use this actionsheet when user is editing or creating a new WiFi network
	func presentAttemptTodismissActionSheet(saveHandler: ((UIAlertAction) -> Void)?, discardHandler: ((UIAlertAction) -> Void)?, completionHandler: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let saveAction = UIAlertAction(title: "Save WiFi", style: .default, handler: saveHandler)
		let discardAction = UIAlertAction(title: "Discard", style: .default, handler: discardHandler)
		let resumeAction = UIAlertAction(title: "Resume Editing", style: .cancel)

		[saveAction, discardAction, resumeAction].forEach(alertController.addAction)
		present(alertController, animated: true)
	}


	/// Use when user long presses on QR code imageView in DetailVC or when the user selects either print or share from options action sheet in Detail VC
	func presentShareQRActionSheet(title: String?, message: String?, shareQRHandler: ((UIAlertAction) -> Void)? = nil, shareViewHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let shareQRAction = UIAlertAction(title: "QR Code Only", style: .default, handler: shareQRHandler)
		let shareViewAction = UIAlertAction(title: "QR Code & Network Info", style: .default, handler: shareViewHandler)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

		[shareQRAction, shareViewAction, cancelAction].forEach(alertController.addAction)
        present(alertController, animated: true, completion: completionHandler)
    }


	// Use this alert when user selects ellipsis leading swipe action to share QR code
	func presentOptionsActionSheetOnTableVC(wifi: Wifi, printOrShareHandler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
		let messageStr = """
		Nickname: \(wifi.nickname ?? "")
		Network: \(wifi.networkName ?? "")
		"""
		let alertController = UIAlertController(title: "Print or Share", message: messageStr, preferredStyle: .actionSheet)

		let printOrShareAction = UIAlertAction(title: "Print or Share", style: .default, handler: printOrShareHandler)
		let shareConfig = UIImage.SymbolConfiguration(pointSize: 25)
		let shareImage = UIImage(systemName: "arrow.up.doc.fill", withConfiguration: shareConfig)
		printOrShareAction.setValue(shareImage, forKey: "image")

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[printOrShareAction, cancelAction].forEach(alertController.addAction)
		present(alertController, animated: true, completion: completion)
	}


	/// Use this action sheet when user taps ellipsis on DetailVC
	func presentOptionsActionSheet(favoriteStr: String,
											 favoriteImage: UIImage,
											 deleteHandler: ((UIAlertAction) -> Void)? = nil,
											 editHandler: ((UIAlertAction) -> Void)? = nil,
											 favoriteHandler: ((UIAlertAction) -> Void)? = nil,
											 shareAndPrintHandler: ((UIAlertAction) -> Void)? = nil,
											 completion: (() -> Void)? = nil) {

		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
		let editAction = UIAlertAction(title: "Edit", style: .default, handler: editHandler)
		let favoriteAction = UIAlertAction(title: favoriteStr, style: .default, handler: favoriteHandler)
		let shareOrPrintAction = UIAlertAction(title: "Share or Print", style: .default, handler: shareAndPrintHandler)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		let configuration = UIImage.SymbolConfiguration(pointSize: 20)
		editAction.setValue(UIImage(systemName: "square.and.pencil", withConfiguration: configuration), forKey: "image")
		favoriteAction.setValue(favoriteImage.withConfiguration(configuration), forKey: "image")
		shareOrPrintAction.setValue(UIImage(systemName: "arrow.up.doc.fill", withConfiguration: configuration), forKey: "image")

		[deleteAction, editAction, favoriteAction, shareOrPrintAction, cancelAction].forEach(alertController.addAction)
		present(alertController, animated: true, completion: completion)

	}


	/// Use this action sheet if user selects delete when promted by action sheet from ellipsis on DetailVC -> Used for single deletion
	func presentSecondaryDeleteAlertSingle(wifi: Wifi, deleteHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
		let deleteStr = "Are you sure you want to delete \(wifi.nickname ?? "this WiFi")?"
		let alertController = UIAlertController(title: deleteStr, message: nil, preferredStyle: .actionSheet)

		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[deleteAction, cancelAction].forEach(alertController.addAction)
		present(alertController, animated: true, completion: completionHandler)
	}


	func presentSecondaryDeleteAlertMultiple(count: Int? = 0, deleteHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
		// This should never be prompted if count is 0 as the user will not have the option to multi select
		let multiDeleteStr = "Are you sure you want to delete \(count ?? 0) networks?"
		let singleDeleteStr = "Are you sure you want to delete this network?"
		let deleteStr = count == 1 ? singleDeleteStr : multiDeleteStr

		let alertController = UIAlertController(title: deleteStr, message: "This cannot be undone.", preferredStyle: .actionSheet)

		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		[deleteAction, cancelAction].forEach(alertController.addAction)
		present(alertController, animated: true, completion: completionHandler)
	}


	// MARK: - FaceID Alerts
	func presentFailedVerificationWithFaceIDAlert() {
		let alertController = UIAlertController(title: "Verification Failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		present(alertController, animated: true)
	}


	func presentBiometryNotAvailableAlert() {
		let alertController = UIAlertController(title: "Biometry Failed", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		present(alertController, animated: true)
	}
}
