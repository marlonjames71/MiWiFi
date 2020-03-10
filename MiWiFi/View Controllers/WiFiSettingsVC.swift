//
//  WiFiSettingsVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 1/20/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import MessageUI

protocol WiFiSettingsVCDelegate: class {
	func deselectRow()
}

class WiFiSettingsVC: UIViewController, WiFiSettingsVCDelegate {

	private let miSettingsTableView = UITableView(frame: .zero, style: .grouped)
	private let reuseIdentifier = "SettingsCell"

	private let contactArr: [Settings] = [
		Settings(title: "Share MiWiFi", iconName: "heart.fill",
				 color: .systemPink, renderingMode: .alwaysOriginal,
				 config: .standardConfiguration),
		Settings(title: "Rate MiWiFi", iconName: "star.fill",
				 color: .systemOrange, renderingMode: .alwaysOriginal,
				 config: .standardConfiguration),
		Settings(title: "Contact Us", iconName: "paperplane.fill",
				 color: .miGlobalTint, renderingMode: .alwaysOriginal,
				 config: .standardConfiguration),
		Settings(title: "Report a Bug", iconName: "ant.fill",
				 color: .miSecondaryAccent, renderingMode: .alwaysOriginal,
				 config: .standardConfiguration)

	]

	private let creditArr: [Settings] = [Settings(title: "Acknowledgements", iconName: "qrcode",
												  color: .miAddButtonColor, renderingMode: .alwaysOriginal,
												  config: .standardConfiguration)]

	private var indexPath: IndexPath?

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
		configureSettingsTableView()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let indexPath = indexPath else { return }
		miSettingsTableView.deselectRow(at: indexPath, animated: true)
	}


	func deselectRow() {
		guard let indexPath = indexPath else { return }
		miSettingsTableView.deselectRow(at: indexPath, animated: true)
	}


	private func configureSettingsTableView() {
		view.addSubview(miSettingsTableView)
		miSettingsTableView.translatesAutoresizingMaskIntoConstraints = false
		miSettingsTableView.frame = view.bounds
		miSettingsTableView.rowHeight = 50
		miSettingsTableView.backgroundColor = .miBackground

		miSettingsTableView.delegate = self
		miSettingsTableView.dataSource = self
		miSettingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
	}

}


extension WiFiSettingsVC: MFMailComposeViewControllerDelegate {
	func setupComposeVC(subject: String) -> MFMailComposeViewController {
		let composeVC = MFMailComposeViewController()
		composeVC.navigationBar.tintColor = .miGlobalTint
		composeVC.modalPresentationStyle = .overFullScreen
		composeVC.mailComposeDelegate = self
		composeVC.setToRecipients(["support@august-light.com"])
		composeVC.setSubject(subject)
		return composeVC
	}


	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		switch result {
		case .cancelled:
			controller.dismiss(animated: true, completion: nil)
		case .saved:
			controller.dismiss(animated: true, completion: nil)
		case .sent:
			let sentAlert = UIAlertController(title: "Your email has been sent", message: nil, preferredStyle: .alert)
			sentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			controller.dismiss(animated: true) {
				self.present(sentAlert, animated: true, completion: nil)
			}
		case .failed:
			let errorAlert = UIAlertController(title: "Oops, an error has occured", message: nil, preferredStyle: .alert)
			errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			controller.dismiss(animated: true) {
				self.present(errorAlert, animated: true, completion: nil)
			}
		@unknown default:
			fatalError()
		}
	}
}


extension WiFiSettingsVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}


	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Contact & Share"
		case 1:
			return "Acknowledgements"
		default:
			break
		}

		return ""
	}

	func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Contact the developer if you have an idea or spot a bug."
		case 1:
			return "Credits for 3rd party technology used to make the app even better."
		default:
			break
		}

		return nil
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return contactArr.count
		case 1:
			return creditArr.count
		default:
			break
		}

		return 2
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		cell.backgroundColor = .miSecondaryBackground
		cell.accessoryType = .disclosureIndicator

		switch indexPath.section {
		case 0:
			cell.textLabel?.text = contactArr[indexPath.row].title
			cell.imageView?.image = contactArr[indexPath.row].iconImage
		case 1:
			cell.textLabel?.text = creditArr[indexPath.row].title
			cell.imageView?.image = creditArr[indexPath.row].iconImage
		default:
			break
		}
		return cell
	}


	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				shareApp()
				tableView.deselectRow(at: indexPath, animated: true)
			case 1:
				navigateToComposeAppStoreRating()
				tableView.deselectRow(at: indexPath, animated: true)
			case 2:
				if MFMailComposeViewController.canSendMail() {
					let generalComposeVC = setupComposeVC(subject: "General")
					present(generalComposeVC, animated: true) {
						self.deselectRow()
					}
				} else {
					presentBasicAlert(controllerTitle: "Mail services are not available", controllerMessage: "Your mail app appears to not be configured", actionTitle: "OK")
					deselectRow()
				}
			case 3:
				if MFMailComposeViewController.canSendMail() {
					let bugComposeVC = setupComposeVC(subject: "Bug Report")
					present(bugComposeVC, animated: true) {
						self.deselectRow()
					}
				} else {
					presentBasicAlert(controllerTitle: "Mail services are not available", controllerMessage: "Your mail app appears to not be configured", actionTitle: "OK")
					tableView.deselectRow(at: indexPath, animated: true)
				}
			default:
				break
			}
		case 1:
			let acknowledgementVC = MiWiFiAcknowledgmentVC()
			acknowledgementVC.delegate = self
			acknowledgementVC.modalPresentationStyle = .overFullScreen
			acknowledgementVC.modalTransitionStyle = .crossDissolve
			present(acknowledgementVC, animated: true)
		default:
			break
		}

		self.indexPath = indexPath
//		tableView.deselectRow(at: indexPath, animated: true)
	}
}
