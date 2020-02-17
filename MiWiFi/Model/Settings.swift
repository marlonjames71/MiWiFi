//
//  Settings.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

struct Settings {
	let title: String
	let iconName: String
	let color: UIColor
	let renderingMode: UIImage.RenderingMode
	let config: UIImage.SymbolConfiguration

	var iconImage: UIImage {
		let image = UIImage(systemName: iconName,
							withConfiguration: config)!
			.withTintColor(color, renderingMode: renderingMode)
		return image
	}
}
