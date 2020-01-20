//
//  Alerts.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

struct Alerts {
	static func showOptionsActionSheet(vc: WiFiTableVC) {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		let editAction = UIAlertAction(title: "Edit Order", style: .default) { (action) in
			// Code goes here
		}

		editAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		editAction.setValue(UIImage(systemName: "text.alignright"), forKey: "image")

		let selectAction = UIAlertAction(title: "Select", style: .default) { (action) in
			// code goes here
		}

		selectAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
		selectAction.setValue(UIImage(systemName: "largecircle.fill.circle"), forKey: "image")

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
		
		[editAction, selectAction, cancelAction].forEach { actionSheet.addAction($0) }
		vc.present(actionSheet, animated: true)
	}
}

extension UIAlertController {
	override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		self.view.tintColor = .miTintColor
    }
}
