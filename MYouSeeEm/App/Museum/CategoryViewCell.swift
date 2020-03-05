//
//  CategoryViewCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/2/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewCell: UICollectionViewCell {
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
    
    var photoId: String? {
        didSet {
            prepare()
        }
    }
    
    func returnImage(category: String, subcategory: String, photoId: String) -> UIImage? {
        let categoryName = category.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let subcategoryName = subcategory.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let photoIdentifier = photoId.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "\(categoryName).\(subcategoryName).\(photoIdentifier)")
    }
    
    func prepare() {
        guard let category = category else { return }
        guard let subcategory = subcategory else { return }
        guard let photoId = photoId else { return }
        subcategoryTitleLabel.text = photoId
        subcategoryImageView.image = returnImage(category: category, subcategory: subcategory, photoId: photoId)
    }
}
