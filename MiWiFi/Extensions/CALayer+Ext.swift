//
//  CALayer+Ext.swift
//  MiWiFi
//
//  Created by Marlon Raskin on 2/23/20.
//  Copyright © 2020 Marlon Raskin. All rights reserved.
//

import UIKit

extension CALayer {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: bounds))
            maskLayer.fillRule = .evenOdd
        }

        maskLayer.path = path.cgPath

        mask = maskLayer
    }
}
