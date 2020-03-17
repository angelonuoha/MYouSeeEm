//
//  ShadowCellView.swift
//  Zuvy
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
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
