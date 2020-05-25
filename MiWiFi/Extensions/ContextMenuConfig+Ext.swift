//
//  ContextMenuConfig+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/24/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

protocol WiFiTableViewConfigurationDelegate: class {
	func didUpdateFavorite(wifi: Wifi, indexPath: IndexPath)
}

protocol ISPTableViewConfigurationDelegate: class {
	func showAddISPVCForEditing(isp: ISP)
}

protocol ISPUpdateDelegate: class {
	func didUpdateISP()
}

extension UIContextMenuConfiguration {
	class func newWiFiTableViewConfiguration(wifi: Wifi,
											 delegate: WiFiTableViewConfigurationDelegate,
											 indexPath: IndexPath) -> UIContextMenuConfiguration {

		return UIContextMenuConfiguration(identifier: wifi.menuID, previewProvider: { () -> UIViewController? in
			return WIFIDetailVC(with: wifi)
		}, actionProvider: { action in

			let favoriteStr = wifi.isFavorite ? "Unfavorite" : "Favorite"
			let favStar = UIImage(systemName: "star")
			let unfavStar = UIImage(systemName: "star.fill")?.withTintColor(.miFavoriteTint, renderingMode: .alwaysOriginal)
			let starImage = wifi.isFavorite ? unfavStar : favStar

			let favorite = UIAction(title: favoriteStr, image: starImage) { action in
				delegate.didUpdateFavorite(wifi: wifi, indexPath: indexPath)
			}

			let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { UIAction in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
					WifiController.shared.delete(wifi: wifi)
				}
			}

			let deleteMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash.fill"), options: .destructive, children: [deleteAction])

			return UIMenu(title: "WiFi: \(wifi.nickname ?? "")", identifier: UIMenu.Identifier(rawValue: "favorite"), children: [favorite, deleteMenu])
		})
	}


	class func newISPTableViewConfiguration(isp: ISP,
											delegate: ISPTableViewConfigurationDelegate,
											indexPath: IndexPath) -> UIContextMenuConfiguration {

		return UIContextMenuConfiguration(identifier: isp.menuID, previewProvider: nil) { action in

			let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
				delegate.showAddISPVCForEditing(isp: isp)
			}

			let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { UIAction in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
					ISPController.shared.deleteISP(isp: isp)
				}
			}

			let deleteMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash.fill"), options: .destructive, children: [deleteAction])

			return UIMenu(title: "ISP: \(isp.name ?? "")", identifier: UIMenu.Identifier(rawValue: "delete"), children: [editAction, deleteMenu])
		}
	}
}
