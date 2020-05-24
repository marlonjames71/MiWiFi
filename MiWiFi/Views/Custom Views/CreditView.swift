//
//  CreditView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/24/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

protocol CreditViewDelegate: class {
	func dismissTapped()
	func needsSafariVCPresented(with url: URL)
}

class CreditView: UIView, UITextViewDelegate {

	weak var delegate: CreditViewDelegate!

	private let iconImageView = MiWiFiIconImageView()
	private let titleLabel = MiWiFiBodyLabel(textAlignment: .center, fontSize: 27)
	private let creditTextView = UITextView()
	private let dismissButton = MiWiFiButton(backgroundColor: .miIconTint, tintColor: .white, textColor: .white, title: "Dismiss", image: nil)

	private let padding: CGFloat = 20

	let appURL = "twitter://user?screen_name=_MarlonJames"
	let webURL = URL(string: "https://twitter.com/_MarlonJames")

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		configureSelf()
		configureTitleLabel()
		configureIconImageView()
		configureStackView()
		configureDismissButton()
		configureCreditTextView()
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureSelf() {
		self.translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = .miBackground

		layer.cornerRadius = 20
		layer.cornerCurve = .continuous
		clipsToBounds = true
		layer.borderColor = UIColor.miGlobalTint.cgColor
		layer.borderWidth = 0.8
	}


	private func configureTitleLabel() {
		titleLabel.text = "Acknowledgements"
		titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}


	private func configureIconImageView() {
		addSubview(iconImageView)

		NSLayoutConstraint.activate([
			iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
			iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			iconImageView.widthAnchor.constraint(equalToConstant: 30),
			iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
		])

		iconImageView.icon = .qr
	}


	private func configureCreditTextView() {
		creditTextView.translatesAutoresizingMaskIntoConstraints = false
		creditTextView.delegate = self
		creditTextView.isSelectable = true
		creditTextView.isEditable = false
		creditTextView.backgroundColor = .clear

		let str = """
		MiWiFi was created by Marlon Raskin in an effort to let guests connect to your WiFi network easier and without giving them your password.\
		 It uses an API called QRettyCode to generate the beautiful QR Code that you see when you create a new network.\
		 Go check it out! 😉
		"""
		let attrStr = NSMutableAttributedString(string: str, attributes: [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.label])
		let nameLinkRange = (attrStr.string as NSString).range(of: "Marlon Raskin")
		let frameworkRange = (attrStr.string as NSString).range(of: "QRettyCode")
		attrStr.addAttribute(.link, value: "https://twitter.com/_MarlonJames", range: nameLinkRange)
		attrStr.addAttribute(.link, value: "https://github.com/mredig/QRettyCode", range: frameworkRange)
		let linkAttributes: [NSAttributedString.Key : Any] = [
			.foregroundColor: UIColor.miGlobalTint,
			.underlineStyle: NSUnderlineStyle.single.rawValue,
			.underlineColor: UIColor.miAddButtonColor
		]

		creditTextView.linkTextAttributes = linkAttributes
		creditTextView.attributedText = attrStr

		creditTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
	}


	private func configureDismissButton() {
		dismissButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
		dismissButton.addTarget(self, action: #selector(dismissTapped(_:)), for: .touchUpInside)
	}


	private func configureStackView() {
		let stackView = UIStackView.fillStackView(spacing: 20, with: [titleLabel, creditTextView, dismissButton])
		addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: padding),
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
		])
	}


	func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
		switch interaction {
		case .invokeDefaultAction:
			if !URL.absoluteString.lowercased().contains("twitter") {
				delegate.needsSafariVCPresented(with: URL)
			} else {
				if UIApplication.shared.canOpenURL(URL) {
					UIApplication.shared.open(URL, options: [:], completionHandler: nil)
				} else {
					delegate.needsSafariVCPresented(with: URL)
				}
			}
			return false
		case .preview:
			return false
		case .presentActions:
			return false
		@unknown default:
			return false
		}
	}


	@objc private func dismissTapped(_ sender: MiWiFiButton) {
		delegate.dismissTapped()
		
	}
}



