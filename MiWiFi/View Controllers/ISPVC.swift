//
//  ISPVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 4/25/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

protocol ISPVCDelegate {
	func animationDidFinish()
}

final class ISPVC: UIViewController {

	private let wifi: Wifi
	private let scrollView = UIScrollView()
	private let stackView = UIStackView()
	private let addISPButton = NewISPButton()
	private let haptic = UIImpactFeedbackGenerator(style: .medium)
	private let copyAlertView = CopyAlertView()
	private var ispView: ISPContainerView?

	var delegate: ISPVCDelegate?


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		configureView()
		configureNavBar()
		configureScrollView()
		configureStackView()
		configureAddButton()
		loadISP()
		configureCopyAlert()
		setupCopyAlertShadow()
		haptic.prepare()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("I will appear")
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
		ispView = ISPContainerView(frame: .zero, isp: isp)
		stackView.addArrangedSubview(ispView ?? UIView())
		ispView?.delegate = self
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
		// Add button should only appear when an ISP hasn't been added yet
		guard wifi.isp == nil else { return }
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


	private func configureCopyAlert() {
		
		view.addSubview(copyAlertView)

		NSLayoutConstraint.activate([
			copyAlertView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
			copyAlertView.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant: 100),
			copyAlertView.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -100),
			copyAlertView.heightAnchor.constraint(equalToConstant: 50)
		])

		copyAlertView.alpha = 0
	}


	private func setupCopyAlertShadow() {
		copyAlertView.layer.shadowPath = UIBezierPath(rect: copyAlertView.bounds).cgPath
		copyAlertView.layer.shadowRadius = 12
		copyAlertView.layer.shadowOffset = .zero
		copyAlertView.layer.shadowOpacity = 0.2
	}


	// MARK: - Actions
	@objc private func dismissVC() {
		dismiss(animated: true)
	}


	@objc private func showAddISPVC() {
		haptic.impactOccurred()
		let addISPVC = AddISPVC(with: wifi)
		addISPVC.delegate = self
		addISPVC.modalPresentationStyle = .overFullScreen
		addISPVC.modalTransitionStyle = .crossDissolve
		present(addISPVC, animated: true)
	}


	@objc private func showISPTableVC() {
		let ispTableVC = ISPTableVC()
		ispTableVC.wifi = wifi
		ispTableVC.delegate = self
		let navController = UINavigationController(rootViewController: ispTableVC)
		present(navController, animated: true)
	}


	private func animateCopyAlert() {
		copyAlertView.animateFromBottomWithTranslationTo(x: 0, y: -130, completion: {
			self.ispView?.copyButton.isEnabled = true
		})
	}
}


extension ISPVC: ISPContainerViewDelegate {
	func showCopyAlert() {
		animateCopyAlert()
	}
}


extension ISPVC: AddISPDelegate, ISPTableVCDelegate {
	func removeISPViewFromStackView() {
		for view in stackView.arrangedSubviews {
			view.isHidden = true
			stackView.removeArrangedSubview(view)
		}
	}

	func didFinishAddingISP() {
		removeISPViewFromStackView()
		loadISP()
	}

	func didFinishChoosingISP() {
		removeISPViewFromStackView()
		loadISP()
	}
}
