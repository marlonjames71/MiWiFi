//
//  MiWiFiAcknowledgmentVC.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import SafariServices

class MiWiFiAcknowledgmentVC: UIViewController, UITextViewDelegate {

	private let creditView = ISPContainerView()
	private let iconImageView = MiWiFiIconImageView()
	private let titleLabel = MiWiFiBodyLabel(textAlignment: .center, fontSize: 27)
	private let creditTextView = UITextView()
	private let dismissButton = MiWiFiButton(backgroundColor: .miIconTint, tintColor: .white, textColor: .white, title: "Dismiss", image: nil)

	private let padding: CGFloat = 20

	var isCreditViewOffCentered: Bool?

	let appURL = "twitter://user?screen_name=_MarlonJames"
	let webURL = URL(string: "https://twitter.com/_MarlonJames")

	weak var delegate: WiFiSettingsVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = UIColor.miSecondaryBackground.withAlphaComponent(0.65)
		isCreditViewOffCentered = true
		configureCreditView()
		configureIconImageView()
		configureTitleLabel()
		configureCreditTextView()
		configureDismissButton()
		configureStackView()
		setupCreditViewForAnimation()

    }


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animate()
	}


	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		animate()
	}


	private func setupCreditViewForAnimation() {
		let destination = CGPoint(x: view.frame.midX, y: view.frame.midY + (creditView.frame.height / 2))
		let offset = view.convert(destination, to: creditView)
		creditView.transform = CGAffineTransform(translationX: 0, y: offset.y)
		creditView.alpha = 0
	}


	private func animate() {
		if isCreditViewOffCentered! {
			isCreditViewOffCentered = false
			UIView.animate(withDuration: 0.8,
						   delay: 0,
						   usingSpringWithDamping: 0.7,
						   initialSpringVelocity: 0.6,
						   options: [.curveEaseOut],
						   animations: {
				self.creditView.transform = .identity
				self.creditView.alpha = 1
			})
		} else {
			isCreditViewOffCentered = true
			UIView.animate(withDuration: 0.6) {
				self.creditView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.midY + self.creditView.frame.height)
				self.creditView.alpha = 0
			}
		}
	}


	private func configureCreditView() {
		view.addSubview(creditView)

		creditView.alpha = 0

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
		switch interaction {
		case .invokeDefaultAction:
			if !URL.absoluteString.lowercased().contains("twitter") {
				presentSafariVC(with: URL)
			} else {
				if UIApplication.shared.canOpenURL(URL) {
					UIApplication.shared.open(URL, options: [:], completionHandler: nil)
				} else {
					presentSafariVC(with: URL)
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
		dismiss(animated: true) {
			self.delegate.deselectRow()
		}
	}
}
