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
		// Editing styles don't seem to match what's actually happening
		// Without the line below, the icon disappears even when swiping on the cell. Line below fixes that
		guard editingStyle != .delete else { return }
		if editing {
			animateLabelConstraints(setToNormal: true)
		} else {
			animateLabelConstraints(setToNormal: false)
		}
		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}


	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		UIView.animate(withDuration: 0.3) {
			if selected {
				self.container.backgroundColor = UIColor.miIconTint.withAlphaComponent(0.2)
			} else {
				self.container.backgroundColor = .miSecondaryBackground
			}
		}
		
		guard isEditing else { return }
		UIView.animate(withDuration: 0.3) {
			if selected {
				self.animateContainerConstraints(setToNormal: true)
			} else {
				self.animateContainerConstraints(setToNormal: false)
			}
		}

		UIView.animate(withDuration: 0.3) {
			self.layoutIfNeeded()
		}
	}


	private func animateContainerConstraints(setToNormal: Bool) {
		if setToNormal {
			guard containerLeadingConstraintNormal.isActive else { return }
			NSLayoutConstraint.deactivate([containerLeadingConstraintNormal])
			NSLayoutConstraint.activate([containerLeadingConstraintEdit])

		} else {
			guard containerLeadingConstraintEdit.isActive else { return }
			NSLayoutConstraint.deactivate([containerLeadingConstraintEdit])
			NSLayoutConstraint.activate([containerLeadingConstraintNormal])
		}
	}


	private func animateLabelConstraints(setToNormal: Bool) {
		if setToNormal {
			guard labelsLeadingConstraintNormal.isActive else { return }
			UIView.animate(withDuration: 0.15) {
				self.iconImageView.alpha = 0
			}
			NSLayoutConstraint.deactivate([labelsLeadingConstraintNormal])
			NSLayoutConstraint.activate([labelsLeadingConstraintEdit])
		} else {
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

		configureIconImageView()
		configureLockImageView()
	}


	private func configureConstraints() {
		// Container
		containerLeadingConstraintNormal = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10)
		containerLeadingConstraintNormal.isActive = true
		containerLeadingConstraintEdit = container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
		containerLeadingConstraintEdit.isActive = false

		// labelStackView
		labelStackView.translatesAutoresizingMaskIntoConstraints = false
		labelsLeadingConstraintNormal = labelStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12)
		labelsLeadingConstraintNormal.isActive = true
		labelsLeadingConstraintEdit = labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60)
		labelsLeadingConstraintEdit.isActive = false
	}


	private func configureContainer() {
		contentView.addSubview(container)

		NSLayoutConstraint.activate([
			container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
			container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
			container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
		])
	}


	private func configureLabels() {
		labelStackView = UIStackView.fillStackView(spacing: 8, with: [nicknameLabel, networkLabel])

		container.addSubview(labelStackView)
		labelStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			labelStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
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

		guard let wifi = wifi else { return }
		iconImageView.tintColor = wifi.isFavorite == true ? UIColor.miFavoriteTint : UIColor.miIconTint
		iconImageView.image = UIImage(systemName: wifi.iconName ?? "house.fill", withConfiguration: configuration)
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
