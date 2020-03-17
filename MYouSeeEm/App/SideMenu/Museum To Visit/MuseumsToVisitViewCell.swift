//
//  MuseumsToVisitViewCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class MuseumsToVisitViewCell: UICollectionViewCell {
    @IBOutlet weak var shadowView: ShadowCellView!
    @IBOutlet weak var subcategoryImageView: UIImageView!
    @IBOutlet weak var subcategoryTitleBackView: UIView!
    @IBOutlet weak var subcategoryTitleLabel: UILabel!
    
        override func awakeFromNib() {
            shadowView.clipsToBounds = false
        }
        
        var subcategory: String? {
            didSet {
                prepare()
            }
        }
        
        func returnImage(subcategory: String) -> UIImage? {
            let geography = subcategory.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "&", with: "and")
            print(geography)
            return UIImage(named: "museumstovisit.\(geography)")
        }
        
        func prepare() {
            guard let subcategory = subcategory else { return }
            subcategoryImageView.image = returnImage(subcategory: subcategory)
        }
}

