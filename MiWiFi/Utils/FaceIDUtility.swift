//
//  FaceIDUtility.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 4/1/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol FaceIDManagerDelegate: AnyObject {
	func showPasswordRequestedFailed()
	func biometricAuthenticationNotAvailable()
}

enum FaceIDManager {

	static func requestAuth(reply: @escaping (Bool, Error?) -> Void) {
		let context = LAContext()
		context.localizedFallbackTitle = "Please use your passcode"
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
			let reason = "Authentication is required for you to continue"

			let biometricType = context.biometryType == .faceID ? "Face ID" : "Touch ID"
			print("Supported Biometric type is: \( biometricType )")

			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: reply)
		}
	}
}
