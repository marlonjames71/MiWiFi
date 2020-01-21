//
//  WiFiTableVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 12/31/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

class WiFiTableVC: UIViewController {

	// MARK: - Properties & Outlets
	let wifiTableView = UITableView(frame: .zero, style: .plain)
	let addWiFiButton = MiWiFiButton(backgroundColor: .miTintColor,
									 tintColor: .miTintColor,
									 textColor: .white,
									 title: "Add WiFi",
									 image: nil)

	let wifiController = WifiController()

	lazy var fetchedResultsController: NSFetchedResultsController<Wifi> = {
		let fetchRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
		let favoriteDescriptor = NSSortDescriptor(key: "isFavorite", ascending: false)
		let nameDescriptor = NSSortDescriptor(key: "name", ascending: true)
		fetchRequest.sortDescriptors = [favoriteDescriptor, nameDescriptor]

		let moc = CoreDataStack.shared.mainContext
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
																	managedObjectContext: moc,
																	sectionNameKeyPath: nil,
																	cacheName: nil)
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print("error performing initial fetch for frc: \(error)")
		}
		return fetchedResultsController
	}()


	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground

		configureTabBar()
		configureNavController()
		configureListTableView()
		configureAddWIFIButton()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		wifiTableView.reloadData()
	}

	private func configureTabBar() {
		if let appearance = tabBarController?.tabBar.standardAppearance.copy() {
			appearance.backgroundImage = UIImage()
			appearance.shadowImage = UIImage()
			appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
			appearance.shadowColor = .clear
		}
	}

	private func configureNavController() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTintColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTintColor,
																   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]
		
		let optionsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(optionsButtonTapped(_:)))
		navigationItem.rightBarButtonItem = optionsButton
	}

	private func configureListTableView() {
		view.addSubview(wifiTableView)
		wifiTableView.translatesAutoresizingMaskIntoConstraints = false
		wifiTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "WifiCell")
		NSLayoutConstraint.activate([
			wifiTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			wifiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			wifiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			wifiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
		])
		wifiTableView.tableFooterView = UIView()
		wifiTableView.dataSource = self
		wifiTableView.delegate = self
		wifiTableView.rowHeight = 60
	}

	private func configureAddWIFIButton() {
		view.addSubview(addWiFiButton)

		NSLayoutConstraint.activate([
			addWiFiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			addWiFiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
			addWiFiButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			addWiFiButton.heightAnchor.constraint(equalToConstant: 40)
		])
		addWiFiButton.addTarget(self, action: #selector(addWifiButtonTapped), for: .touchUpInside)
	}

	// MARK: - Actions

	@objc private func optionsButtonTapped(_ sender: UIBarButtonItem) {
		Alerts.showOptionsActionSheet(vc: self)
	}

	@objc private func addWifiButtonTapped() {
		let addWifiVC = AddWIFIVC()
		addWifiVC.wifiController = wifiController
		addWifiVC.modalPresentationStyle = .overFullScreen
		present(addWifiVC, animated: true)
	}
}

extension WiFiTableVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let wifi = fetchedResultsController.object(at: indexPath)
		let cell = wifiTableView.cellForRow(at: indexPath) as? SubtitleTableViewCell
		let detailAction = UIContextualAction(style: .normal, title: "View") { action, view, completion in
			let detailVC = WIFIDetailVC()
			let navController = UINavigationController(rootViewController: detailVC)
			self.present(navController, animated: true)
			completion(true)
		}

		let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { action, view, completion in
			self.wifiController.updateWifi(wifi: wifi,
										   name: wifi.name ?? "",
										   wifiName: wifi.wifiName ?? "",
										   password: wifi.password ?? "",
										   locationDesc: wifi.locationDesc ?? "",
										   iconName: wifi.iconName ?? "home.fill",
										   isFavorite: !wifi.isFavorite)
			cell?.updateViews()
			completion(true)
		}

		detailAction.backgroundColor = .miTintColor
		detailAction.image = UIImage(systemName: "qrcode")

		favoriteAction.backgroundColor = .systemOrange
		favoriteAction.image = UIImage(systemName: "star.fill")

		let configuration = UISwipeActionsConfiguration(actions: [favoriteAction, detailAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
			let wifi = self.fetchedResultsController.object(at: indexPath)
			self.wifiController.delete(wifi: wifi)
			completion(true)
		}

		action.image = UIImage(systemName: "trash.fill")
		action.backgroundColor = .systemPink
		let configuration = UISwipeActionsConfiguration(actions: [action])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = UIColor.miTintColor.withAlphaComponent(0.2)
			return view
		}()

		let cell = tableView.dequeueReusableCell(withIdentifier: "WifiCell", for: indexPath) as? SubtitleTableViewCell
		let wifi = fetchedResultsController.object(at: indexPath)
		cell?.wifi = wifi

		cell?.selectedBackgroundView = backgroundView

		return cell ?? UITableViewCell()
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let wifi = fetchedResultsController.object(at: indexPath)
		let detailVC = WIFIDetailVC()
		detailVC.wifi = wifi
		detailVC.wifiController = wifiController
		navigationController?.pushViewController(detailVC, animated: true)
	}
}

// MARK: - Fetched Results Controller Delegate
extension WiFiTableVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		wifiTableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		wifiTableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		let indexSet = IndexSet([sectionIndex])
		switch type {
		case .insert:
			wifiTableView.insertSections(indexSet, with: .fade)
		case .delete:
			wifiTableView.deleteSections(indexSet, with: .fade)
		default:
			print(#line, #file, "unexpected NSFetchedResultsChangeType: \(type)")
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		switch type {
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			wifiTableView.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			wifiTableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			wifiTableView.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			wifiTableView.deleteRows(at: [indexPath], with: .automatic)
		@unknown default:
			print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
		}
	}
}

extension WiFiTableVC: AddWiFiVCDelegate {
	func didFinishSaving() {
		DispatchQueue.main.async {
			self.wifiTableView.reloadData()
		}
	}
}
