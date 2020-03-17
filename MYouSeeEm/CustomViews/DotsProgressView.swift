//
//  DotsProgressView.swift
//  Zuvy
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

@IBDesignable class DotsProgressView: UIView {
    
    @IBInspectable var dotSide: Int = 8
    @IBInspectable var totalDots: Int = 3
    @IBInspectable var currentDot: Int = 0
    @IBInspectable var spacing: Int = 6

    private var dotSize: CGSize {
        return .init(width: max(0, dotSide), height: max(0, dotSide))
    }

    override func awakeFromNib() {
        prepare()
    }
    
    override func prepareForInterfaceBuilder() {
        prepare()
    }
    
    override var intrinsicContentSize: CGSize {
        let n: CGFloat = CGFloat(totalDots)
        let h: CGFloat = dotSize.height
        let w: CGFloat = CGFloat(spacing) * (n - 1) + CGFloat(dotSize.width) * n
        return .init(width: w, height: h)
    }
    
    func prepare() {
        backgroundColor = .clear
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let currentColor = UIColor.accent.withAlphaComponent(0.55).cgColor
        let color = UIColor.accent.withAlphaComponent(0.15).cgColor
        for i in 0 ..< totalDots {
            let x: CGFloat = CGFloat(i) * dotSize.width + (i == 0 ? 0 : CGFloat(i) * CGFloat(spacing))
            let y: CGFloat = 0
            let dotRect = CGRect(origin: .init(x: x, y: y), size: dotSize)
            context.addEllipse(in: dotRect)
            context.setFillColor(i == currentDot ? currentColor : color)
            context.fillPath()
        }
    }
}
