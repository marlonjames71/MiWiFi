//
//  Wifi+Convenience.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension Wifi {
	@discardableResult convenience init(name: String, wifiName: String, password: String, locationDesc: String, iconName: String, isFavorite: Bool = false, context: NSManagedObjectContext) {
		self.init(context: context)
		self.name = name
		self.wifiName = wifiName
		self.password = password
		self.locationDesc = locationDesc
		self.iconName = iconName
		self.isFavorite = isFavorite
	}
}
