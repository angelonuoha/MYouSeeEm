//
//  SignInViewCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/16/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

class SignInViewCell: UICollectionViewCell {
    @IBOutlet weak var onboardingImageView: UIImageView!
    
    var onboardingPictures: String! {
        didSet {
            prepare()
        }
    }
    
    func prepare() {
        onboardingImageView.image = returnImage(order: onboardingPictures)
    }
    
    func returnImage(order: String) -> UIImage? {
        let picture = order.lowercased()
        return UIImage(named: "onboarding.\(picture)")
    }
    
    
}
