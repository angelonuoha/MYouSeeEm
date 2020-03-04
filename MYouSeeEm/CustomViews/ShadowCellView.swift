//
//  ShadowCellView.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 24.12.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit


@IBDesignable class ShadowCellView: UIView {
    
    override var frame: CGRect {
        didSet {
            layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 2, radius: 5, blur: 5, spread: 2)
        }
    }
    
    override var bounds: CGRect {
        didSet {
            layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 2, radius: 5, blur: 5, spread: 2)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 2, radius: 5, blur: 5, spread: 2)
    }
    
    override func awakeFromNib() {
        layer.applySketchShadow(color: .black, alpha: 0.25, x: 0, y: 2, radius: 5, blur: 5, spread: 2)
    }
}
