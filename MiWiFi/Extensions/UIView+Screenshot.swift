//
//  UIView+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/30/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIView {

	func screenshot() -> UIImage {
		let render = UIGraphicsImageRenderer(size: bounds.size)

		return render.image { _ in
			drawHierarchy(in: bounds, afterScreenUpdates: true)
		}
	}
}
