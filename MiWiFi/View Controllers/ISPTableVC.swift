//
//  ISPTableVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class ISPTableVC: UIViewController {

	private let ispTableView = UITableView(frame: .zero, style: .grouped)
	private let identifier = "ISPCell"

    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureTableView()
    }


	private func configureView() {
//		view.backgroundColor = .miSecondaryBackground
		view.addSubview(ispTableView)
		title = "ISP List"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
		
	}

	private func configureTableView() {
		ispTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
		ispTableView.rowHeight = 60

		ispTableView.backgroundColor = .miSecondaryBackground
		ispTableView.frame = view.bounds

		ispTableView.delegate = self
		ispTableView.dataSource = self
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}
}


extension ISPTableVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		cell.backgroundColor = .miSecondaryBackground
		cell.textLabel?.text = "\(indexPath.row + 1)"
		cell.textLabel?.font = .roundedFont(ofSize: 17, weight: .medium)
		let config = UIImage.SymbolConfiguration(pointSize: 20)
		if indexPath.row == 4 {
			cell.imageView?.image = UIImage(systemName: "largecircle.fill.circle", withConfiguration: config)?.withTintColor(.miGlobalTint, renderingMode: .alwaysOriginal)
		} else {
			cell.imageView?.image = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(.miGlobalTint, renderingMode: .alwaysOriginal)
		}

		return cell
	}
}
