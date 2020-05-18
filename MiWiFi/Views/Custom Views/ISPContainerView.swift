//
//  MiWiFiContainerView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData
import LinkPresentation

protocol ISPContainerViewDelegate: class {
	func showCopyAlert()
}

class ISPContainerView: UIView {

	private let isp: ISP
	private let copyHaptic = UIImpactFeedbackGenerator(style: .rigid)
	private let callHaptic = UIImpactFeedbackGenerator(style: .medium)
	private let linkStackView = UIStackView()
	private let buttonStackView = UIStackView()
	lazy var callButton = CallButton(frame: .zero, isp: isp)
	lazy var copyButton = CopyButton()

	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.roundedFont(ofSize: 22, weight: .medium)
		label.textColor = .miIconTint
		label.text = isp.name
		return label
	}()

	private let activityIndicator = UIActivityIndicatorView()
	private var provider = LPMetadataProvider()
	private var linkView = LPLinkView()
	private var currentMetadata: LPLinkMetadata?

	weak var delegate: ISPContainerViewDelegate?

	// MARK: - Init
	init(frame: CGRect = .zero, isp: ISP) {
		self.isp = isp
		super.init(frame: frame)
		configureMainView()
		configureButtons()
		configureLinkView()
		loadLinkView()
		copyHaptic.prepare()
		callHaptic.prepare()
	}

	override init(frame: CGRect) {
		fatalError("Use init with isp: ISP")
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Configure Methods
	private func configureMainView() {
		// Configure View
		backgroundColor = .miSecondaryBackground
		layer.cornerRadius = 16
		layer.cornerCurve = .continuous
		translatesAutoresizingMaskIntoConstraints = false
	}


	private func configureLinkView() {
		addSubview(linkStackView)
		linkStackView.translatesAutoresizingMaskIntoConstraints = false
		linkStackView.axis = .vertical
		linkStackView.alignment = .fill
		linkStackView.distribution = .fill
		linkStackView.spacing = 16
		linkStackView.addArrangedSubview(buttonStackView)
		linkStackView.insertArrangedSubview(activityIndicator, at: 1)
		linkStackView.insertArrangedSubview(titleLabel, at: 0)

		NSLayoutConstraint.activate([
			linkStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
			linkStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
			linkStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			linkStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
		])
	}


	private func configureButtons() {
		buttonStackView.axis = .horizontal
		buttonStackView.alignment = .fill
		buttonStackView.distribution = .fill
		buttonStackView.spacing = 8
		[callButton, copyButton].forEach { buttonStackView.addArrangedSubview($0) }

		callButton.addTarget(self, action: #selector(makeCall(_:)), for: .touchUpInside)
		copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)

		NSLayoutConstraint.activate([
			callButton.heightAnchor.constraint(equalToConstant: 50),
			copyButton.heightAnchor.constraint(equalToConstant: 50),
			copyButton.widthAnchor.constraint(equalToConstant: 50),
		])

		buttonStackView.isHidden = true
	}


	// MARK: - Helper Methods
	func loadLinkView() {
		guard !activityIndicator.isAnimating else {
			cancel()
			return
		}

		activityIndicator.startAnimating()
		buttonStackView.isHidden = true
		provider = LPMetadataProvider()
		provider.timeout = 5

		linkView.removeFromSuperview()
		guard let urlString = isp.urlString,
			let url = URL(string: urlString) else {
				resetViews()
				return
		}
		linkView = LPLinkView(url: url)

		fetchMetadata(for: url)
		linkStackView.insertArrangedSubview(linkView, at: 1)
	}


	private func fetchMetadata(for url: URL) {
		if let existingMetadata = MetadataCache.retrieve(urlString: url.absoluteString) {
			linkView = LPLinkView(metadata: existingMetadata)
			resetViews()
			currentMetadata = existingMetadata
		} else {
			provider.startFetchingMetadata(for: url) { [weak self] metadata, error in
				guard let self = self else { return }
				guard let metadata = metadata, error == nil else {
					if let error = error as? LPError {
						DispatchQueue.main.async { [weak self] in
							guard let self = self else { return }

							print(error.prettyString) // Fix to use tiny popup alert
							self.resetViews()
						}
					}
					return
				}

				self.currentMetadata = metadata
				if let imageProvider = metadata.imageProvider {
					metadata.iconProvider = imageProvider
				}
				MetadataCache.cache(metadata: metadata)

				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }

					self.linkView.metadata = metadata
					self.resetViews()
				}
			}
		}
	}


	private func cancel() {
		provider.cancel()
		provider = LPMetadataProvider()
		resetViews()
	}


	private func resetViews() {
		activityIndicator.stopAnimating()
		buttonStackView.isHidden = false
	}


	private func open(_ url: URL) {
		let app = UIApplication.shared
		if app.canOpenURL(url) {
			app.open(url, options: [:])
		}
	}


	// MARK: - Actions
	@objc private func makeCall(_ sender: CallButton) {
		callHaptic.impactOccurred()
		guard let number = isp.phone,
			let numberURL = URL(string: "tel:\(number)") else { return }
		open(numberURL)
	}


	@objc private func copyButtonTapped() {
		copyHaptic.impactOccurred()
		copyButton.isEnabled = false
		guard let number = isp.phone else { return }
		delegate?.showCopyAlert()
		let pasteboard = UIPasteboard.general
		pasteboard.string = number
	}
}


extension ISPContainerView: ISPVCDelegate {
	func animationDidFinish() {
		copyButton.isEnabled = true
	}
}


extension ISPContainerView: UIActivityItemSource {
	func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
		return "website.com"
	}

	func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
		return currentMetadata?.originalURL
	}

	func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
		return currentMetadata
	}
}
