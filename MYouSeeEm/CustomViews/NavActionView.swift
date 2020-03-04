//
//  NavActionView.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 23.12.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit

@IBDesignable class NavActionView: UIView {
    
    override func prepareForInterfaceBuilder() {
        prepare()
    }
    
    override func awakeFromNib() {
        prepare()
    }
    
    override func layoutMarginsDidChange() {
        prepare()
    }
    
    func prepare() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = .init(width: 0, height: 5)
        layer.shadowOpacity = 0.15
    }
    
}
