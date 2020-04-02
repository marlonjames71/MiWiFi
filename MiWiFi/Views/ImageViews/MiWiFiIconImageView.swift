//
//  MiWiFiIconImageView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/24/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiIconImageView: UIImageView {

	enum Icon: String {
		case network = "wifi"
		case password = "shield.lefthalf.fill"
		case qr = "qrcode"
	}


	var icon: Icon? {                                                                                                                                                                                                                       
		didSet {
			configure()
		}
	}


	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		configure()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configure() {
		translatesAutoresizingMaskIntoConstraints = false
		contentMode = .center

		let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)

		guard let icon = icon else { return }

		switch icon {
		case .network:
			image = UIImage(systemName: icon.rawValue, withConfiguration: configuration)
		case .password:
			image = UIImage(systemName: icon.rawValue, withConfiguration: configuration)
		case .qr:
			image = UIImage(systemName: icon.rawValue, withConfiguration: configuration)?
				.withTintColor(.miAddButtonColor, renderingMode: .alwaysOriginal)
		}
	}
}
