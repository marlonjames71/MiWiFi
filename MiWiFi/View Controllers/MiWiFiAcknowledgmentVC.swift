//
//  MiWiFiAcknowledgmentVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiAcknowledgmentVC: UIViewController, UITextViewDelegate {

	private let creditView = MiWiFiContainerView()
	private let iconImageView = MiWiFiIconImageView()
	private let titleLabel = MiWiFiBodyLabel(textAlignment: .center, fontSize: 27)
	private let creditTextView = UITextView()
	private let dismissButton = MiWiFiButton(backgroundColor: .miGlobalTint, tintColor: .white, textColor: .white, title: "Dismiss", image: nil)

	private let padding: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
		configureCreditView()
		configureIconImageView()
		configureTitleLabel()
		configureCreditTextView()
		configureDismissButton()
		configureStackView()
    }


	private func configureCreditView() {
		view.addSubview(creditView)

		NSLayoutConstraint.activate([
			creditView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			creditView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			creditView.widthAnchor.constraint(equalToConstant: 300),
		])
	}


	private func configureIconImageView() {
		creditView.addSubview(iconImageView)

		NSLayoutConstraint.activate([
			iconImageView.topAnchor.constraint(equalTo: creditView.topAnchor, constant: padding),
			iconImageView.centerXAnchor.constraint(equalTo: creditView.centerXAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 30),
			iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
		])

		iconImageView.icon = .qr
	}


	private func configureTitleLabel() {
		titleLabel.text = "Acknowledgements"
		titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}


	private func configureCreditTextView() {
		creditTextView.translatesAutoresizingMaskIntoConstraints = false
		creditTextView.isEditable = false
		creditTextView.backgroundColor = .clear

		let str = """
		MiWiFi was created by Marlon Raskin. It uses a third party API to generate the beautiful QR Code that you see when you create a new network.\
		You can find the API here: QReddyCode.
		"""
		let attrStr = NSMutableAttributedString(string: str, attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.label])
		attrStr.addAttribute(.link, value: "https://twitter.com/_MarlonJames", range: NSRange(location: 22, length: 13))
		attrStr.addAttribute(.link, value: "https://github.com/mredig/QRettyCode", range: NSRange(location: 166, length: 11))
		creditTextView.attributedText = attrStr

		creditTextView.heightAnchor.constraint(equalToConstant: 130).isActive = true
	}


	private func configureDismissButton() {
		dismissButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		dismissButton.addTarget(self, action: #selector(dismissTapped(_:)), for: .touchUpInside)
	}


	private func configureStackView() {
		let stackView = UIStackView.fillStackView(spacing: 20, with: [titleLabel, creditTextView, dismissButton])
		creditView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: padding),
			stackView.leadingAnchor.constraint(equalTo: creditView.leadingAnchor, constant: padding),
			stackView.bottomAnchor.constraint(equalTo: creditView.bottomAnchor, constant: -padding),
			stackView.trailingAnchor.constraint(equalTo: creditView.trailingAnchor, constant: -padding)
		])
	}


	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		if UIApplication.shared.canOpenURL(URL) {
			UIApplication.shared.open(URL, options: [:], completionHandler: nil)
		}

		return false
	}


	@objc private func dismissTapped(_ sender: MiWiFiButton) {
		dismiss(animated: true)
	}
}
