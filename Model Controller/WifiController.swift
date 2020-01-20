//
//  WifiController.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class WifiController {
	static let shared = WifiController()

	func addWifi(name: String, wifiName: String, password: String, locationDesc: String, iconName: String, isFavorite: Bool = false) {
		Wifi(name: name, wifiName: wifiName, password: password, locationDesc: locationDesc, iconName: iconName, isFavorite: isFavorite, context: .mainContext)
		saveToPersistentStore()
	}

	func updateWifi(wifi: Wifi, name: String, wifiName: String, password: String, locationDesc: String, iconName: String, isFavorite: Bool) {
		wifi.name = name
		wifi.wifiName = wifiName
		wifi.password = password
		wifi.locationDesc = locationDesc
		wifi.iconName = iconName
		wifi.isFavorite = isFavorite
		saveToPersistentStore()
	}

	func delete(wifi: Wifi) {
		let moc = NSManagedObjectContext.mainContext
		moc.delete(wifi)
		saveToPersistentStore()
	}

	func loadFromPersistentStore() -> [Wifi] {
		let fetchRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
		let moc = NSManagedObjectContext.mainContext

		do {
			let wifiList = try moc.fetch(fetchRequest)
			return wifiList
		} catch {
			NSLog("Error fetching wifi list: \(error)")
			return []
		}
	}

	func saveToPersistentStore() {
		let moc = NSManagedObjectContext.mainContext

		do {
			try moc.save()
		} catch {
			NSLog("Error saving main context: \(error)")
			moc.reset()
		}
	}
}
