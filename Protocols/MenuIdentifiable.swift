//
//  MenuIdentifiable.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/3/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

protocol MenuIdentifiable {

    var passwordIDStr: String { get }

}

extension MenuIdentifiable {

    var menuID: NSString {
        NSString(string: passwordIDStr)
    }

    func isReferenced(by configuration: UIContextMenuConfiguration) -> Bool {
        return menuID == configuration.identifier as? NSString
    }

}

extension Array where Element: MenuIdentifiable {

    func item(for configuration: UIContextMenuConfiguration) -> Element? {
        return first(where: { $0.menuID == configuration.identifier as? NSString })
    }

    func index(for configuration: UIContextMenuConfiguration) -> Index? {
        return firstIndex(where: { $0.menuID == configuration.identifier as? NSString })
    }

}
