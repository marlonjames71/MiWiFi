//
//  WiFiSettingsVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class WiFiSettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .miBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor]

		if let appearance = tabBarController?.tabBar.standardAppearance.copy() {
			appearance.backgroundImage = UIImage()
			appearance.shadowImage = UIImage()
			appearance.backgroundColor = .miBackground
			appearance.shadowColor = .clear
			tabBarItem.standardAppearance = appearance
		}

		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
	}

}
