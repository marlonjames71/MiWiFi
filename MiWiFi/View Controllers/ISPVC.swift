//
//  ISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 4/25/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

final class ISPVC: UIViewController {

	let wifi: Wifi
	let scrollView = UIScrollView()
	let stackView = UIStackView()
	let addISPButton = NewISPButton()

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureNavBar()
		configureScrollView()
		configureStackView()
		configureAddButton()

		for _ in 0..<3 {
			let testView = UIView()
			testView.translatesAutoresizingMaskIntoConstraints = false
			testView.heightAnchor.constraint(equalToConstant: 150).isActive = true
			testView.backgroundColor = UIColor.miGlobalTint.withAlphaComponent(0.2)
			testView.layer.cornerRadius = 12
			testView.layer.cornerCurve = .continuous
			stackView.addArrangedSubview(testView)
		}
    }

	init(wifi: Wifi) {
		self.wifi = wifi
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		let addISPVC = AddISPVC()
		addISPVC.modalPresentationStyle = .overFullScreen
		addISPVC.modalTransitionStyle = .crossDissolve
		present(addISPVC, animated: true)
	}
}
