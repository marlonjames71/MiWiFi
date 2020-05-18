//
//  LPError+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import LinkPresentation

extension LPError {
	var prettyString: String {
		switch self.code {
		case .metadataFetchCancelled:
			return "Metadata fetch cancelled."
		case .metadataFetchFailed:
			return "Metadata fetch failed."
		case .metadataFetchTimedOut:
			return "Metadata fetch timed out."
		case .unknown:
			return "Metadata fetch unknown."
		@unknown default:
			return "Metadata fetch unknown."
		}
	}
}
