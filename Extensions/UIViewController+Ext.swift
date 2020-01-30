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


	func presentSaveActionSheet(vc: AddWIFIVC, title: String? = nil, message: String? = nil) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

		let saveAction = UIAlertAction(title: "Save WiFi", style: .default) { _ in
			vc.saveWifi()
			vc.dismiss(animated: true)
		}

		let discardAction = UIAlertAction(title: "Discard", style: .default) { _ in
			vc.dismiss(animated: true)
		}

		let resumeAction = UIAlertAction(title: "Resume Editing", style: .cancel)

		[discardAction, saveAction, resumeAction].forEach { ac.addAction($0) }
		present(ac, animated: true)
	}
}
