//
//  HomeSubcategoryCell.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 22.12.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit

class HomeSubcategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var subcategoryImageView: UIImageView!
    @IBOutlet weak var subcategoryTitleBackView: UIView!
    @IBOutlet weak var subcategoryTitleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        shadowView.clipsToBounds = false
    }
    
    var subcategory: String? {
        didSet {
            prepare()
        }
    }
    
    var category: String? {
        didSet {
            prepare()
        }
    }
        
    func prepare() {
        subcategoryTitleLabel.text = subcategory
        guard let category = category else { return }
        //subcategoryImageView.image = subcategory.image(category: category) ?? category.image
    }
}
