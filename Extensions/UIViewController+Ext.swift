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
		self.present(activityController, animated: true)
	}


	// MARK: - Alerts
	/// Use this actionsheet when user is editing or creating a new WiFi network
	func presentAttemptTodismissActionSheet(saveHandler: ((UIAlertAction) -> Void)?, discardHandler: ((UIAlertAction) -> Void)?, completionHandler: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let saveAction = UIAlertAction(title: "Save WiFi", style: .default, handler: saveHandler)
		let discardAction = UIAlertAction(title: "Discard", style: .default, handler: discardHandler)
		let resumeAction = UIAlertAction(title: "Resume Editing", style: .cancel)

		[saveAction, discardAction, resumeAction].forEach { alertController.addAction($0) }
		present(alertController, animated: true)
	}


	/// Use when user long presses on QR code imageView in DetailVC or when the user selects either print or share from options action sheet in Detail VC
	func presentShareQRActionSheet(title: String?, message: String?, shareQRHandler: ((UIAlertAction) -> Void)? = nil, shareViewHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let shareQRAction = UIAlertAction(title: "Share QR Code Only", style: .default, handler: shareQRHandler)
		let shareViewAction = UIAlertAction(title: "Share QR & Network Info", style: .default, handler: shareViewHandler)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(shareQRAction)
		alertController.addAction(shareViewAction)
		alertController.addAction(cancelAction)

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

		[printOrShareAction, cancelAction].forEach { alertController.addAction($0) }
		present(alertController, animated: true, completion: completion)
	}


	
}
