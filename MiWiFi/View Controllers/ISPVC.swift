//
//  ISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 4/25/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

final class ISPVC: UIViewController {


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureNavBar()
    }

// MARK: - Configure Methods
	private func configureView() {
		view.backgroundColor = .miBackground
	}


	private func configureNavBar() {
		navigationController?.navigationBar.tintColor = .miGlobalTint
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
		.font : UIFont.roundedFont(ofSize: 20, weight: .bold)]

		title = "ISP"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))

	}


	private func configureInputFields() {

	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}

}
