//
//  RoundImageView.swift
//  Zuvy
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
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
