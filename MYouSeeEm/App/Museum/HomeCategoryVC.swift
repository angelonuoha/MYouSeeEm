//
//  HomeCategoryVC.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 14.12.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit

class HomeCategoryVC: UIViewController {
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    
    var subcategory: CategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

}

extension HomeCategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategory?.names.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        if let subcategory = subcategory {
            cell.subcategory = subcategory.category
            cell.photoId = subcategory.names[indexPath.row]
            cell.category = subcategory.superCategory
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
            if let author = subcategory.[Constants.subcategory.author], let instagram = subcategoryData[Constants.subcategory.instagram], let description = subcategoryData[Constants.subcategory.description], let date = subcategoryData[Constants.subcategory.date], let additionalInfo = subcategoryData[Constants.subcategory.additionalInfo] {
                let subcategory = SubcategoryModel(author: author, instagram: instagram, description: description, date: date, additionalInfo: additionalInfo, category: selectedCategory)
                self.delegate?.showSubcategories(subcategory: subcategory)
            }
        }*/
    }
}

extension HomeCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let w = view.frame.width
        return .init(width: w, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.bounds.width
        let side = (w - 50.0) / 2.0
        return .init(width: side, height: side)
    }
}
