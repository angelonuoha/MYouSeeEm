//
//  HomeResultsVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit

class HomeResultsVC: UIViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultDescription: UITextView!
    @IBOutlet weak var instagramHandle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var subcategoryDetail: SubcategoryModel?
    
    
    func prepare() {
        if let subcategoryDetail = subcategoryDetail {
            resultImageView.image = returnImage(category: subcategoryDetail.category, subcategory: subcategoryDetail.subcategory, photoId: subcategoryDetail.photoId)
            resultDescription.text = subcategoryDetail.description
            instagramHandle.text = subcategoryDetail.instagram
            author.text = subcategoryDetail.author
            date.text = subcategoryDetail.date
            additionalInfo.text = subcategoryDetail.additionalInfo
        }
    }
    
    func returnImage(category: String, subcategory: String, photoId: String) -> UIImage? {
        let categoryName = category.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let subcategoryName = subcategory.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        let photoIdentifier = photoId.lowercased().replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        return UIImage(named: "\(categoryName).\(subcategoryName).\(photoIdentifier)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
}
