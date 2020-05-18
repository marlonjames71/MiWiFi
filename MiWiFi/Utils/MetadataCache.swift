//
//  MetadataCache.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import LinkPresentation

struct MetadataCache {
	static func cache(metadata: LPLinkMetadata) {
		// 1. Check if the metadata already exists for this URL
		do {
			guard retrieve(urlString: metadata.url!.absoluteString) == nil else {
				return
			}

			// 2. Transform the metadata to a Data object and set requiringSecureCoding to true
			let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)

			// 3. Save to user defaults
			UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
		}
		catch let error {
			print("Error when caching: \(error.localizedDescription)")
		}
	}

	static func retrieve(urlString: String) -> LPLinkMetadata? {
		do {
			// 1. Check if data exists for a particular url string
			guard
				let data = UserDefaults.standard.object(forKey: urlString) as? Data,
				// 2. Ensure that if can be transformed to an LPLinkMetadata object
				let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data)
				else { return nil }
			return metadata
		}
		catch let error {
			print("Error when caching: \(error.localizedDescription)")
			return nil
		}
	}

	// 1
	static var savedURLs: [String] {
		UserDefaults.standard.object(forKey: "SavedURLs") as? [String] ?? []
	}

	// 2
	static func addToSaved(metadata: LPLinkMetadata) {
		guard var links = UserDefaults.standard.object(forKey: "SavedURLs") as? [String] else {
			UserDefaults.standard.set([metadata.url!.absoluteString], forKey: "SavedURLs")
			return
		}

		guard !links.contains(metadata.url!.absoluteString) else { return }

		links.append(metadata.url!.absoluteString)
		UserDefaults.standard.set(links, forKey: "SavedURLs")
	}
}
