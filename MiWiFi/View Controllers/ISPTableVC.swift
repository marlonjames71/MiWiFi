//
//  ISPTableVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/16/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

protocol ISPTableVCDelegate: class {
	func didFinishChoosingISP()
	func didDeleteISP(wifi: Wifi?)
}

class ISPTableVC: UIViewController {

	var wifi: Wifi?

	weak var delegate: ISPTableVCDelegate!

	private let ispTableView = UITableView(frame: .zero, style: .grouped)
	private let identifier = "ISPCell"

	lazy var fetchedResultsController: NSFetchedResultsController<ISP> = {
		let fetchRequest: NSFetchRequest<ISP> = ISP.fetchRequest()
		let nameDescriptor = NSSortDescriptor(keyPath: \ISP.name, ascending: true)
		fetchRequest.sortDescriptors = [nameDescriptor]

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

    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureTableView()
    }


	private func configureView() {
//		view.backgroundColor = .miSecondaryBackground
		title = "ISP List"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																		.font : UIFont.roundedFont(ofSize: 35, weight: .heavy)]
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
																   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddISPVC))
	}

	private func configureTableView() {
		view.addSubview(ispTableView)
		ispTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
		ispTableView.rowHeight = 60

		ispTableView.backgroundColor = .miSecondaryBackground
		ispTableView.tintColor = .miGlobalTint
		view.constrain(subview: ispTableView)

		ispTableView.delegate = self
		ispTableView.dataSource = self
	}


	@objc private func dismissVC() {
		dismiss(animated: true)
	}


	@objc internal func showAddISPVC() {
		guard let wifi = wifi else { return }
		let addISPVC = AddISPVC(with: wifi, shouldAttachToWifi: false)
		addISPVC.delegate = self
		addISPVC.modalPresentationStyle = .overFullScreen
		addISPVC.modalTransitionStyle = .crossDissolve
		present(addISPVC, animated: true)
	}
}


extension ISPTableVC: AddISPDelegate {
	func didFinishAddingISP() {
		delegate.didFinishChoosingISP()
	}
}


extension ISPTableVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		fetchedResultsController.sections?.count ?? 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		fetchedResultsController.sections?[section].numberOfObjects ?? 0
	}

	private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
		let isp = fetchedResultsController.object(at: indexPath)
		cell.backgroundColor = .miSecondaryBackground
		cell.textLabel?.text = "\(isp.name ?? "No Name")"
		cell.textLabel?.font = .roundedFont(ofSize: 20, weight: .medium)

		if wifi?.isp == isp {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		configureCell(cell, at: indexPath)

		return cell
	}

	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let isp = self.fetchedResultsController.object(at: indexPath)
		return UIContextMenuConfiguration.newISPTableViewConfiguration(isp: isp, delegate: self, indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let isp = fetchedResultsController.object(at: indexPath)
		guard let wifi = wifi else { return }
		WifiController.shared.updateISP(wifi: wifi, isp: isp)
		delegate.didFinishChoosingISP()
		dismissVC()
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		"Swipe left on any cell to delete or edit an existing internet service provider."
	}
}


extension ISPTableVC: ISPTableViewConfigurationDelegate {
	func showAddISPVCForEditing(isp: ISP) {
		guard let wifi = wifi else { return }
		let addISPVC = AddISPVC(with: wifi, shouldAttachToWifi: true)
		addISPVC.isp = isp
		addISPVC.delegate = self
		addISPVC.modalPresentationStyle = .overFullScreen
		addISPVC.modalTransitionStyle = .crossDissolve
		present(addISPVC, animated: true)
	}
}


extension ISPTableVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		ispTableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		ispTableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange sectionInfo: NSFetchedResultsSectionInfo,
					atSectionIndex sectionIndex: Int,
					for type: NSFetchedResultsChangeType) {
		let indexSet = IndexSet([sectionIndex])
		switch type {
		case .insert:
			ispTableView.insertSections(indexSet, with: .fade)
		case .delete:
			ispTableView.deleteSections(indexSet, with: .fade)
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
			ispTableView.insertRows(at: [newIndexPath], with: .automatic)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			if let cell = ispTableView.cellForRow(at: indexPath) {
				configureCell(cell, at: newIndexPath)
			}
			ispTableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			ispTableView.reloadRows(at: [indexPath], with: .automatic)
		case .delete:
			guard let indexPath = indexPath else { return }
			ispTableView.deleteRows(at: [indexPath], with: .automatic)
			// update ISPVC if ISP has been deleted
			delegate.didDeleteISP(wifi: wifi)
		@unknown default:
			print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
		}
	}
}
