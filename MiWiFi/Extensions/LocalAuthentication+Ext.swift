//
//  LocalAuthentication+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 3/9/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import Foundation
import LocalAuthentication

extension LAError.Code {
	func getErrorDescription() -> String {

	   switch self {
	   case .authenticationFailed:
		   return "Authentication was not successful, because user failed to provide valid credentials."

		case .appCancel:
		   return "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."

	   case .invalidContext:
		   return "LAContext passed to this call has been previously invalidated."

	   case .notInteractive:
		   return "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property."

	   case .passcodeNotSet:
		   return "Authentication could not start, because passcode is not set on the device."

	   case .systemCancel:
		   return "Authentication was canceled by system (e.g. another application went to foreground)."

	   case .userCancel:
		   return "Authentication was canceled by user (e.g. tapped Cancel button)."

	   case .userFallback:
		   return "Authentication was canceled, because the user tapped the fallback button (Enter Password)."

	   default:
		return "Error code \(self) not found"
	   }
	}
}
