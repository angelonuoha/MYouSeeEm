//
//  MYouSeeEmAuthViewController.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 4/1/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI

class MYouSeeEmAuthViewController: FUIAuthPickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        setFirebaseNavLogo()
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFirebaseNavLogo() {
        let logo = UIImage(named: "MYouSeeEmLogo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        let width = UIScreen.main.bounds.size.width - 10
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -100, width: width, height: height))
        imageViewBackground.image = UIImage(named: "MYouSeeEmFullLogo")

        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFit
        view.insertSubview(imageViewBackground, at: 1)
    }
}
