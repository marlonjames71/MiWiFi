//
//  ImageShareSource.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/24/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class ImageShareSource: NSObject, UIActivityItemSource {
	let image: UIImage
	let nickname: String?
	let network: String?
	let password: String?

	init(image: UIImage, nickname: String? = nil, network: String? = nil, password: String? = nil) {
		self.image = image
		self.nickname = nickname
		self.network = network
		self.password = password
		super.init()
	}

	required override init() {
		fatalError()
	}

	public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
		UIImage()
	}

	public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
		let size: CGSize
		let imageScale: CGFloat
		let infoTextSize: CGFloat
		let textColor: UIColor
		let bgColor: UIColor
		if activityType == .print {
			size = CGSize(width: 850, height: 1100)
			imageScale = 0.4
			infoTextSize = 25
			textColor = .black
			bgColor = .white
		} else {
			if nickname != nil, network != nil, password != nil {
				size = CGSize(width: 300, height: 450)
				imageScale = 0.7
				infoTextSize = 14
				textColor = .label
				bgColor = .miBackground
			} else {
				return image
			}
		}

		let renderer = UIGraphicsImageRenderer(size: size)
		guard let cgImage = image.cgImage else { return nil }
		return renderer.image { (graphicsContext) in
			bgColor.setFill()
			graphicsContext.fill(CGRect(origin: .zero, size: size))

			// Flip y to draw image correctly
			graphicsContext.cgContext.translateBy(x: 0, y: size.height)
			graphicsContext.cgContext.scaleBy(x: 1, y: -1)

			let imageSize = CGSize(width: size.width * imageScale, height: size.width * imageScale)
			let imageOrigin = CGPoint(x: (size.width / 2.0) - (CGFloat(imageSize.width) / 2.0), y: (size.height / 2) - (CGFloat(imageSize.height) / 2))
			graphicsContext.cgContext.draw(cgImage, in: CGRect(origin: imageOrigin, size: imageSize))

			// Flip y back to draw text correctly
			graphicsContext.cgContext.scaleBy(x: 1, y: -1)
			graphicsContext.cgContext.translateBy(x: 0, y: -size.height)

			guard let nickname = nickname, let network = network, let password = password else { return }
			let formattedWiFiInfo = "Network\n\(network)\n\nPassword\n\(password)" as NSString

			let pStyle = NSMutableParagraphStyle()
			pStyle.setParagraphStyle(NSParagraphStyle.default)
			pStyle.alignment = .center
			let nicknameAttr: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: 40, weight: .bold), .paragraphStyle: pStyle]
			let infoAttr: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: UIFont.systemFont(ofSize: infoTextSize, weight: .regular), .paragraphStyle: pStyle]

			let textInset = size.width * 0.1
			let networkOrigin = CGPoint(x: textInset, y: (size.height / 2) + (CGFloat(imageSize.height) / 2))
			var passwordOrigin = networkOrigin
			passwordOrigin.y += 35
			let nicknameOrigin = CGPoint(x: textInset, y: ((size.height / 2) - (CGFloat(imageSize.height) / 2) - 75))
			let formattedInfoSize = CGSize(width: size.width - (textInset * 2), height: 1000)
			let formattedNicknameSize = CGSize(width: size.width - (textInset * 2), height: 70)

			nickname.draw(in: CGRect(origin: nicknameOrigin, size: formattedNicknameSize), withAttributes: nicknameAttr)
			formattedWiFiInfo.draw(in: CGRect(origin: networkOrigin, size: formattedInfoSize), withAttributes: infoAttr)
		}.pngData()
	}
}
