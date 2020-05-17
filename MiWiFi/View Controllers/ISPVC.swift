//
//  ISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 4/25/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

final class ISPVC: UIViewController {

	private let wifi: Wifi
	private let scrollView = UIScrollView()
	private let stackView = UIStackView()
	private let addISPButton = NewISPButton()
	private let haptic = UIImpactFeedbackGenerator(style: .medium)


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureNavBar()
		configureScrollView()
		configureStackView()
		configureAddButton()
		loadISP()
		haptic.prepare()
    }

	init(wifi: Wifi) {
		self.wifi = wifi
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func loadISP() {
		guard let isp = wifi.isp else { return }
		let ispView = ISPContainerView(frame: .zero, isp: isp)
		stackView.addArrangedSubview(ispView)
	}


// MARK: - Configure Methods
	private func configureView() {
		view.backgroundColor = .miBackground
	}


	private func configureNavBar() {
		navigationController?.navigationBar.tintColor = .miGlobalTint
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.miTitleColor,
		.font : UIFont.roundedFont(ofSize: 20, weight: .bold)]

		title = wifi.nickname

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showISPTableVC))
	}


	private func configureScrollView() {
		scrollView.alwaysBounceVertical = true
		scrollView.delaysContentTouches = false
		view.addSubview(scrollView)
		scrollView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}


	private func configureAddButton() {
		addISPButton.addTarget(self, action: #selector(showAddISPVC), for: .touchUpInside)
		addISPButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
		stackView.addArrangedSubview(addISPButton)
	}


	private func configureStackView() {
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 12
		stackView.distribution = .fill
		scrollView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		let centerY = stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
		centerY.isActive = true
		centerY.priority = UILayoutPriority.defaultLow

		let bottom = stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
		bottom.isActive = true
		bottom.priority = UILayoutPriority.defaultLow

		NSLayoutConstraint.activate([
			stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
		])
	}


	// MARK: - Actions
	@objc private func dismissVC() {
		dismiss(animated: true)
	}


	@objc private func showAddISPVC() {
		haptic.impactOccurred()
		let addISPVC = AddISPVC(with: wifi)
		addISPVC.modalPresentationStyle = .overFullScreen
		addISPVC.modalTransitionStyle = .crossDissolve
		present(addISPVC, animated: true)
	}


	@objc private func showISPTableVC() {
		let ispTableVC = ISPTableVC()
		let navController = UINavigationController(rootViewController: ispTableVC)
		present(navController, animated: true)
	}
}
