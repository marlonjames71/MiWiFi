//
//  UIAlert+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/31/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIAlertController {
	override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		self.view.tintColor = .miTintColor
    }
}
