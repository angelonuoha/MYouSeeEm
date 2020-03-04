//
//  RoundImageView.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 31.10.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit

@IBDesignable class RoundImageView: UIImageView {
    
    override func prepareForInterfaceBuilder() {
        prepare()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepare()
    }
    
    func prepare() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }

}
