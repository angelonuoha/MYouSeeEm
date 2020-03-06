//
//  UIView+Border.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/6/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

extension UIView {
    // MARK: Debug purposes
    func applyDebugBorder() {
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1
    }
    
    // MARK: - Corners and Borders

    func roundTop(radius:CGFloat) -> Void {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
    
    func roundBottom(radius:CGFloat) -> Void {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = maskLayer
    }
    
    // MARK: - IB Inspectable
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
