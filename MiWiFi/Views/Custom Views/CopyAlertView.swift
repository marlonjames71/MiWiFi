//
//  CopyAlertView.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 5/17/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

class CopyAlertView: UIView {

    override func draw(_ rect: CGRect) {
		layer.cornerRadius = frame.height / 2
		layer.cornerCurve = .continuous
		clipsToBounds = true
    }

	private lazy var label: UILabel = {
		let copyLabel = UILabel()
		copyLabel.text = "Phone Copied!"
		copyLabel.textColor = .miGlobalTint
		copyLabel.font = UIFont.roundedFont(ofSize: 17, weight: .medium)
		copyLabel.textAlignment = .center
		return copyLabel
	}()


	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		configureViewAndLabel()
		translatesAutoresizingMaskIntoConstraints = false
	}


	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	private func configureViewAndLabel() {
		backgroundColor = .miSecondaryBackground
		addSubview(label)
		constrain(subview: label, inset: UIEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7))
	}
}
