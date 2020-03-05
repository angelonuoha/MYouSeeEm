//
//  UIScrollView+Utils.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool, completion: (() -> ())? = nil) {
        let topOffset = self.contentSize.height + self.contentInset.bottom - self.bounds.height
        let contentOffset = CGPoint(x: 0, y: topOffset)
        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func scrollToTop(animated: Bool, completion: (() -> ())? = nil) {
        let topOffset = -self.contentInset.top
        let contentOffset = CGPoint(x: 0, y: topOffset)
        
        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func scrollToRight(animated: Bool, completion: (() -> ())? = nil) {
        let leftOffset = self.contentSize.width + self.contentInset.right - self.bounds.width
        let contentOffset = CGPoint(x: leftOffset, y: 0)
        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func scrollToLeft(animated: Bool, completion: (() -> ())? = nil) {
        let leftOffset = -self.contentInset.left
        let contentOffset = CGPoint(x: leftOffset, y: 0)
        
        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func scrollToCenter(animated: Bool, completion: (() -> ())? = nil) {
        let leftOffset = contentSize.width/2.0 - bounds.size.width/2.0
        let topOffset = contentSize.height/2.0 - bounds.size.height/2.0
        let contentOffset = CGPoint(x: leftOffset, y: topOffset)
        
        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func scrollToHorizontalPage(_ page: Int, animated: Bool, completion: (() -> ())? = nil) {
        let leftOffset = bounds.size.width * CGFloat(page)
        let contentOffset = CGPoint(x: leftOffset, y: 0)

        scrollToOffset(contentOffset, animated: animated, completion: completion)
    }
    
    func currentHorizontalPage() -> Int {
        var base = Int(contentOffset.x / bounds.size.width)
        let leftover = (contentOffset.x / bounds.size.width) - CGFloat(base)
        if leftover >= 0.5 {
            base += 1
        }
        return base
    }
    
    // MARK: Private
    
    fileprivate func scrollToOffset(_ offset: CGPoint, animated: Bool, completion: (() -> ())? = nil) {
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0.0,
                           options: [],
                           animations: {
                            self.contentOffset = offset
            }, completion: { (_) in
                completion?()
            })
        } else {
            self.contentOffset = offset
        }
    }
}
