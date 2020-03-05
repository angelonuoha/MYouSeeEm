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
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noCommentsLabel: UILabel!
    
    var subcategoryDetail: SubcategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        scrollView.scrollToTop(animated: true)
    }
    
    func prepare() {
        if let subcategoryDetail = subcategoryDetail {
            noCommentsLabel.isHidden = true
            resultImageView.image = returnImage(category: subcategoryDetail.category, subcategory: subcategoryDetail.subcategory, photoId: subcategoryDetail.photoId)
            self.title = subcategoryDetail.photoId
            resultDescription.text = subcategoryDetail.description
            resultDescription.isScrollEnabled = false
            resultDescription.isEditable = false
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
}

extension HomeResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCommentsViewCell", for: indexPath) as! HomeCommentsViewCell
        cell.commentLabel.text = "Comment"
        cell.dateLabel.text = "Yesterday"
        cell.userName.text = "Angel Onuoha"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}
