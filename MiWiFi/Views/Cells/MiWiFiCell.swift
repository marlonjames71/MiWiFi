//
//  MiWiFiTCell.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/9/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class MiWiFiCell: UITableViewCell {

	var wifi: Wifi? {
		didSet {
			updateViews()
		}
	}

	var containerLeadingConstraintNormal: NSLayoutConstraint!
	var containerLeadingConstraintEdit: NSLayoutConstraint!
	var labelsLeadingConstraintNormal: NSLayoutConstraint!
	var labelsLeadingConstraintEdit: NSLayoutConstraint!

	lazy var labelStackView = UIStackView()

	let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)

	private lazy var container: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .miSecondaryBackground
		view.layer.cornerRadius = 12
		view.layer.cornerCurve = .continuous
		return view
	}()

	let nicknameLabel = MiWiFiBodyLabel(textAlignment: .left, fontSize: 18)
	let networkLabel = MiWiFiHeaderLabel(textAlignment: .left, fontSize: 12)
	let iconImageView = UIImageView()
	let lockImageView = UIImageView()


	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .miBackground
		configureContainer()
		configureIconImageView()
		configureLockImageView()
		configureLabels()
		configureConstraints()
		accessoryType = .disclosureIndicator
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		if editing {
//			self.leadingConstraintNormal.isActive = false
//			self.leadingConstraintEdit.isActive = true
			animateLabelConstraints(setToNormal: true)
		} else {
//			self.leadingConstraintEdit.isActive = false
//			self.leadingConstraintNormal.isActive = true
			animateLabelConstraints(setToNormal: false)
		}
		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}


	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		UIView.animate(withDuration: 0.3) {
			switch selected {
			case true:
				self.container.backgroundColor = UIColor.miIconTint.withAlphaComponent(0.2)
			case false:
				self.container.backgroundColor = .miSecondaryBackground
			}
		}
		
		guard isEditing else { return }
		UIView.animate(withDuration: 0.3) {
			switch selected {
			case true:
				self.containerLeadingConstraintNormal.isActive = false
				self.containerLeadingConstraintEdit.isActive = true
//				self.markIconAsSelected(basedOn: selected)
			default:
				self.containerLeadingConstraintEdit.isActive = false
				self.containerLeadingConstraintNormal.isActive = true
//				self.markIconAsSelected(basedOn: selected)
			}
		}

		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}


	private func animateIcon(basedOn isEditing: Bool) {
		guard let wifi = wifi else { return }
		UIView.animate(withDuration: 0.3) {
			if isEditing {
				self.iconImageView.image = UIImage(systemName: "circle", withConfiguration: self.configuration)
			} else {
				self.iconImageView.image = UIImage(systemName: wifi.iconName ?? "house.fill", withConfiguration: self.configuration)
			}
			self.layoutIfNeeded()
		}
	}


	private func markIconAsSelected(basedOn isSelected: Bool) {
		UIView.animate(withDuration: 0.2) {
			if isSelected {
				self.iconImageView.image = UIImage(systemName: "largecircle.fill.circle", withConfiguration: self.configuration)
			} else {
				self.iconImageView.image = UIImage(systemName: "circle", withConfiguration: self.configuration)
			}
			self.layoutIfNeeded()
		}
	}


	private func setIconImageToOriginalImageAndColor() {
		guard let wifi = wifi else { return }
		iconImageView.tintColor = wifi.isFavorite == true ? UIColor.miFavoriteTint : UIColor.miIconTint
		iconImageView.image = UIImage(systemName: wifi.iconName ?? "house.fill", withConfiguration: configuration)
	}


	private func animateLabelConstraints(setToNormal: Bool) {
		switch setToNormal {
		case true:
			guard labelsLeadingConstraintNormal.isActive else { return }
			UIView.animate(withDuration: 0.15) {
				self.iconImageView.alpha = 0
			}
			NSLayoutConstraint.deactivate([labelsLeadingConstraintNormal])
			NSLayoutConstraint.activate([labelsLeadingConstraintEdit])

		case false:
			guard labelsLeadingConstraintEdit.isActive else { return }
			NSLayoutConstraint.deactivate([labelsLeadingConstraintEdit])
			NSLayoutConstraint.activate([labelsLeadingConstraintNormal])
			UIView.animate(withDuration: 0.5) {
				self.iconImageView.alpha = 1
			}
		}
	}


	func updateViews() {
		guard let wifi = wifi else { return }
		nicknameLabel.text = wifi.nickname
		networkLabel.text = wifi.networkName

		if let id = wifi.passwordID {
			let password = KeychainWrapper.standard.string(forKey: id.uuidString)
			if password == "" {
				detailTextLabel?.textColor = .systemGray2
			} else {
				detailTextLabel?.textColor = .secondaryLabel
			}
		}

		setIconImageToOriginalImageAndColor()

		configureIconImageView()
		configureLockImageView()
	}


	private func configureConstraints() {
		containerLeadingConstraintNormal = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10)
		containerLeadingConstraintNormal.isActive = true
		containerLeadingConstraintEdit = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
		containerLeadingConstraintEdit.isActive = false

		labelsLeadingConstraintNormal = labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
		labelsLeadingConstraintNormal.isActive = true
		labelsLeadingConstraintEdit = labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60)
		labelsLeadingConstraintEdit.isActive = false
	}


	private func configureContainer() {
		contentView.addSubview(container)

		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
			container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
			container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
		])
	}


	private func configureLabels() {
		nicknameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		networkLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true

		labelStackView = UIStackView.fillStackView(spacing: 8, with: [nicknameLabel, networkLabel])

		container.addSubview(labelStackView)
		labelStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			labelStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
			labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
			labelStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
			labelStackView.trailingAnchor.constraint(equalTo: lockImageView.leadingAnchor, constant: -8)
		])
	}


	private func configureIconImageView() {
		container.addSubview(iconImageView)
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.contentMode = .center

		NSLayoutConstraint.activate([
			iconImageView.heightAnchor.constraint(equalToConstant: 30),
			iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1),
			iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
			iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0)
		])
	}


	private func configureLockImageView() {
		container.addSubview(lockImageView)
		lockImageView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			lockImageView.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor, constant: -16),
			lockImageView.heightAnchor.constraint(equalToConstant: 16),
			lockImageView.widthAnchor.constraint(equalTo: lockImageView.heightAnchor),
			lockImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0)
		])

		guard let id = wifi?.passwordID?.uuidString else { return }
		let password = KeychainWrapper.standard.string(forKey: id)
		lockImageView.tintColor = password != "" ? .miSecondaryAccent : .secondaryLabel
		lockImageView.image = password != "" ? UIImage(systemName: "lock.fill") : UIImage(systemName: "lock.slash.fill")
	}
}
