//
//  Wifi+Convenience.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension Wifi: MenuIdentifiable {
	@discardableResult convenience init(nickname: String, networkName: String, passwordID: UUID, locationDesc: String, iconName: String, isFavorite: Bool = false, context: NSManagedObjectContext) {
		self.init(context: context)
		self.nickname = nickname
		self.networkName = networkName
		self.passwordID = passwordID
		self.locationDesc = locationDesc
		self.iconName = iconName
		self.isFavorite = isFavorite
	}

	var passwordIDStr: String {
		self.passwordID?.uuidString ?? ""
	}
}
