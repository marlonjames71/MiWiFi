//
//  UIFontRounded.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension UIFont {
	static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
		// Will be SF Compact or standard SF in case of failure.
		if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
			return UIFont(descriptor: descriptor, size: fontSize)
		} else {
			return UIFont.systemFont(ofSize: fontSize)
		}
	}

	/// Returns a rounded font of all the same characteristics as the original if it exists. If not, simply returns the old font.
	static func rounded(from oldFont: UIFont) -> UIFont {
		let design = UIFontDescriptor.SystemDesign.rounded
		guard let descriptor = oldFont.fontDescriptor.withDesign(design) else { return oldFont }
		return UIFont(descriptor: descriptor, size: oldFont.pointSize)
	}
}
