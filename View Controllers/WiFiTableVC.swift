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

	enum Mode {
		case view
		case select
	}

	var mode: Mode = .view {
		didSet {
			switch mode {
			case .view:
				navigationItem.leftBarButtonItem = nil
				wifiTableView.setEditing(false, animated: true)
			case .select:
				navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
																   target: self,
																   action: #selector(deleteSelectedWifiObjects(_:)))
				wifiTableView.setEditing(true, animated: true)
			}
		}
	}

	// MARK: - Properties & Outlets
	private let wifiTableView = UITableView(frame: .zero, style: .plain)

	private let addButton = UIButton(type: .system)

	private let emptyStateView = MiWiFiEmptyStateView(message: #"It's so empty in here. Try adding a network by tapping the "+" button below!"#)

	lazy var fetchedResultsController: NSFetchedResultsController<Wifi> = {
		let fetchRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
		let favoriteDescriptor = NSSortDescriptor(keyPath: \Wifi.isFavorite, ascending: false)
		let nameDescriptor = NSSortDescriptor(keyPath: \Wifi.nickname, ascending: true)
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
		view.backgroundColor = .miBackground

		configureTabBar()
		configureNavController()
		configureListTableView()
		configureEmptyStateView()
		configureAddButton()
    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		wifiTableView.reloadData()
		configureNavController()
	}


	private func configureTabBar() {
		if let appearance = tabBarController?.tabBar.standardAppearance.copy() {
			appearance.backgroundImage = UIImage()
			appearance.shadowImage = UIImage()
//			appearance.backgroundColor = UIColor.miBlueGreyBG
			appearance.backgroundColor = .miBackground
			appearance.shadowColor = .clear
			tabBarItem.standardAppearance = appearance
		}
	}


	private func configureNavController() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]

		let count = fetchedResultsController.fetchedObjects?.count ?? 0
		navigationItem.rightBarButtonItem = count > 0 ? editButtonItem : nil
	}

	private func configureEmptyStateView() {
		view.addSubview(emptyStateView)
		emptyStateView.frame = view.bounds
		emptyStateView.isHidden  = fetchedResultsController.fetchedObjects?.count ?? 0 > 0 ? true : false
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
		wifiTableView.backgroundColor = .miBackground
		wifiTableView.allowsMultipleSelection = false
		wifiTableView.allowsSelectionDuringEditing = true
		wifiTableView.allowsMultipleSelectionDuringEditing = true
	}


	private func configureAddButton() {
		view.addSubview(addButton)
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.addTarget(self, action: #selector(addWifiButtonTapped(_:)), for: .touchUpInside)

		addButton.tintColor = .miAddButtonColor
		let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
		addButton.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: configuration), for: .normal)

		NSLayoutConstraint.activate([
			addButton.heightAnchor.constraint(equalToConstant: 60),
			addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor),
			addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
		])
	}


	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		if(editing && !wifiTableView.isEditing){
			mode = .select
		}else{
			mode = .view
		}
	}


	// MARK: - Actions
	@objc private func addWifiButtonTapped(_ sender: UIButton) {
		let addWifiVC = AddWIFIVC()
		let navController = UINavigationController(rootViewController: addWifiVC)
		navController.modalPresentationStyle = .automatic
		present(navController, animated: true)
	}


	@objc private func deleteSelectedWifiObjects(_ sender: UIBarButtonItem) {
		guard let indexPaths = wifiTableView.indexPathsForSelectedRows else { return }
		var wifiObjects: [Wifi] = []
		indexPaths.forEach { wifiObjects.append(fetchedResultsController.object(at: $0)) }

		presentSecondaryDeleteAlertMultiple(count: indexPaths.count, deleteHandler: { _ in
			for wifi in wifiObjects {
				guard let id = wifi.passwordID else { return }
				KeychainWrapper.standard.removeObject(forKey: id.uuidString)
				WifiController.shared.delete(wifi: wifi)
			}
			self.isEditing = false
			self.mode = .view
		})
	}
}


extension WiFiTableVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 1
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
		return true
	}

	func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
		mode = .select
		super.setEditing(true, animated: true)
	}

	func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
		print("\(#function)")
	}


	func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let wifi = fetchedResultsController.object(at: indexPath)
		let cell = wifiTableView.cellForRow(at: indexPath) as? SubtitleTableViewCell

		let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { action, view, completion in
			WifiController.shared.updateFavorite(wifi: wifi, isFavorite: !wifi.isFavorite)
			cell?.updateViews()
			completion(true)
		}

		let star = UIImage(systemName: "star.fill")?.withTintColor(.miFavoriteTint, renderingMode: .alwaysOriginal)
		let starSlash = UIImage(systemName: "star.slash.fill")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
		let starImage = wifi.isFavorite ? starSlash : star
		favoriteAction.backgroundColor = .miBackground
		favoriteAction.image = starImage

		let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}


	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
			let wifi = self.fetchedResultsController.object(at: indexPath)
			self.presentSecondaryDeleteAlertSingle(wifi: wifi, deleteHandler: { _ in
				guard let id = wifi.passwordID else { return }
				KeychainWrapper.standard.removeObject(forKey: id.uuidString)
				WifiController.shared.delete(wifi: wifi)
			})
			completion(true)
		}

		action.image = UIImage(systemName: "trash.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
		action.backgroundColor = .miBackground
		let configuration = UISwipeActionsConfiguration(actions: [action])
		configuration.performsFirstActionWithFullSwipe = true
		return configuration
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let backgroundView: UIView = {
			let view = UIView()
			view.backgroundColor = UIColor.miGrayColor.withAlphaComponent(0.4)
			return view
		}()

		let cell = tableView.dequeueReusableCell(withIdentifier: "WifiCell", for: indexPath) as? SubtitleTableViewCell
		let wifi = fetchedResultsController.object(at: indexPath)
		cell?.wifi = wifi
		cell?.backgroundColor = .miBackground
		cell?.selectedBackgroundView = backgroundView

		return cell ?? UITableViewCell()
	}


	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let wifi = self.fetchedResultsController.object(at: indexPath)
		let nickname = wifi.nickname ?? ""

		let configuration = UIContextMenuConfiguration(identifier: wifi.menuID, previewProvider: { () -> UIViewController? in
			return WIFIDetailVC(with: wifi)
		}) { action in

			let favoriteStr = wifi.isFavorite ? "Unfavorite" : "Favorite"
			let favStar = UIImage(systemName: "star")
			let unfavStar = UIImage(systemName: "star.fill")?.withTintColor(.miFavoriteTint, renderingMode: .alwaysOriginal)
			let starImage = wifi.isFavorite ? unfavStar : favStar

			let favorite = UIAction(title: favoriteStr, image: starImage) { action in
				let cell = tableView.cellForRow(at: indexPath) as? SubtitleTableViewCell
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
					WifiController.shared.updateFavorite(wifi: wifi, isFavorite: !wifi.isFavorite)
					let indexPath = self.wifiTableView.indexPath(for: cell ?? UITableViewCell())
					let newCell = self.wifiTableView.cellForRow(at: indexPath!) as! SubtitleTableViewCell
					newCell.updateViews()
				}
			}

			let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { UIAction in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
					WifiController.shared.delete(wifi: wifi)
				}
			}

			let deleteMenu = UIMenu(title: "Delete", image: UIImage(systemName: "trash.fill"), options: .destructive, children: [deleteAction])

			return UIMenu(title: "WiFi: \(nickname)", identifier: UIMenu.Identifier(rawValue: "favorite"), children: [favorite, deleteMenu])
		}

		return configuration
	}


	func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {

		guard let wifi = fetchedResultsController.fetchedObjects?.item(for: configuration) else { return }

		let viewController = WIFIDetailVC(with: wifi)

		animator.addCompletion { [weak self] in
			guard let self = self else { return }

			self.show(viewController, sender: self)
		}
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !isEditing {
			let wifi = fetchedResultsController.object(at: indexPath)
			let detailVC = WIFIDetailVC(with: wifi)
			navigationController?.pushViewController(detailVC, animated: true)
		}
	}
}


// MARK: - Fetched Results Controller Delegate
extension WiFiTableVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		wifiTableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		if let count = fetchedResultsController.fetchedObjects?.count {
			if navigationItem.rightBarButtonItem == nil && count > 0 {
				navigationItem.rightBarButtonItem = editButtonItem
				UIView.animate(withDuration: 1) {
					self.emptyStateView.isHidden = true
				}
			} else if count == 0 {
				navigationItem.rightBarButtonItem = nil
				emptyStateView.isHidden = false
			}
		}

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
