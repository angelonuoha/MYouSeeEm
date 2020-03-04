//
//  CALayer+Shadow.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/3/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    func applySketchShadow(color: UIColor = .black,
                         alpha: Float = 0.5,
                         x: CGFloat = 0,
                         y: CGFloat = 2,
                         radius: CGFloat = 0,
                         blur: CGFloat = 4,
                         spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        }
    }
}
