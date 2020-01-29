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
}
