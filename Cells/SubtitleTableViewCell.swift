//
//  SubtitleTableViewCell.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func updateViews() {
		guard let wifi = wifi else { return }
		textLabel?.text = wifi.name
		detailTextLabel?.text = wifi.wifiName
		detailTextLabel?.textColor = .secondaryLabel
		imageView?.tintColor = wifi.isFavorite == true ? UIColor.systemOrange : UIColor.miTintColor
		imageView?.image = UIImage(systemName: wifi.iconName ?? "house.fill")
		accessoryType = .disclosureIndicator
	}

}
