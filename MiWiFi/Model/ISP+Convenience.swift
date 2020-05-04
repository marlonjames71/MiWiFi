//
//  ISP+Convenience.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/3/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension ISP {
	@discardableResult convenience init(name: String, urlString: String? = nil, phone: String? = nil, context: NSManagedObjectContext) {
		self.init(context: context)
		self.name = name
		self.urlString = urlString
		self.wifiNetworks = NSOrderedSet(array: [])
		self.phone = phone
	}
}
