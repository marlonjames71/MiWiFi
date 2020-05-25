//
//  ISPController.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/3/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class ISPController {
	static let shared = ISPController()

	/// Will return an ISP if it's needed upon creation. The returned ISP can also be discarded.
	@discardableResult func createISP(name: String, urlString: String? = nil, phone: String? = nil) -> ISP {
		let isp = ISP(name: name, urlString: urlString ?? "", phone: phone ?? "", context: .mainContext)
		saveToPersistentStore()
		return isp
	}


	func updateISP(isp: ISP, name: String? = nil, urlString: String? = nil, phone: String? = nil) {
		if let name = name,
			let urlString = urlString,
			let phone = phone {
			isp.name = name
			isp.urlString = urlString
			isp.phone = phone
		}
		saveToPersistentStore()
	}


	func deleteISP(isp: ISP) {
		let moc = NSManagedObjectContext.mainContext
		moc.delete(isp)
		saveToPersistentStore()
	}


	func unlinkWifi(isp: ISP, wifi: Wifi) {
		isp.removeFromWifiNetworks(wifi)
		saveToPersistentStore()
	}


	func loadFromPersistentStore() -> [ISP] {
		let fetchRequest: NSFetchRequest<ISP> = ISP.fetchRequest()
		let moc = NSManagedObjectContext.mainContext

		do {
			let ispList = try moc.fetch(fetchRequest)
			return ispList
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
