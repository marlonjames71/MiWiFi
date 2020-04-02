//
//  Defaults.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 3/31/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation

fileprivate extension String {
	static let defaultsVersion = "com.augustlight.miwifi.defaultversion"
	static let faceIDEnabled = "FaceIDEnabled"
}

enum DefaultsManager {
	fileprivate static let defaults = UserDefaults.standard

	static var faceIDEnabled: Bool {
		get {
			defaults.object(forKey: .faceIDEnabled) as? Bool ?? true
		}
		set {
			defaults.set(newValue, forKey: .faceIDEnabled)
		}
	}

	static var defaultsVersion: Int {
		get {
			defaults.integer(forKey: .defaultsVersion)
		}
		set {
			defaults.set(newValue, forKey: .defaultsVersion)
		}
	}

	static func migrateDefaults() {
		if defaultsVersion == 0 {
			defaults.set(1, forKey: String.defaultsVersion)
		}
	}
}

extension UserDefaults {
	subscript(key: String) -> Any? {
		get {
			object(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}

	subscript(bool key: String) -> Bool {
		get {
			bool(forKey: key)
		}
		set {
			set(newValue, forKey: key)
		}
	}
}
