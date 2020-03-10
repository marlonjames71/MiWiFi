//
//  UIViewController+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/28/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
	
	func showEmptyStateView(with message: String, in view: UIView) {
		let emptyStateView = MiWiFiEmptyStateView(message: message)
		emptyStateView.frame = view.bounds
		view.addSubview(emptyStateView)
	}


	func share(image: ImageShareSource) {
		let activityController = UIActivityViewController(activityItems: [image], applicationActivities: [])
		present(activityController, animated: true)
	}


	func shareApp() {
		let appID = "1499395426"
		let urlStr = "https://itunes.apple.com/app/id\(appID)"
		let items = [URL(string: urlStr)!]
		let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
		present(ac, animated: true)
	}


	func navigateToComposeAppStoreRating() {
		let appID = "1499395426"
		let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review"
		guard let appStoreURL = URL(string: urlStr), UIApplication.shared.canOpenURL(appStoreURL)  else { return }
		UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
	}


	func presentSafariVC(with url: URL) {
		let safariVC = SFSafariViewController(url: url)
		safariVC.preferredControlTintColor = .miGlobalTint
		present(safariVC, animated: true)
	}


	// MARK: - ToolBar for MultiSelect

}
