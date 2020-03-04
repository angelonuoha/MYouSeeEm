//
//  UIColor+hex.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/3/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init (hex: UInt32) {
        var hex = hex
        let blue = CGFloat(hex % 0x100) / 255.0
        hex >>= 8
        let green = CGFloat(hex % 0x100) / 255.0
        hex >>= 8
        let red = CGFloat(hex) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static var accent: UIColor {
        return .init(hex: 0xef5536)
    }
}
