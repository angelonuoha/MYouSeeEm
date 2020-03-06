//
//  HomeCategoryVC.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit

class HomeCategoryVC: UIViewController {
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    
    var subcategory: CategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }

    func prepare() {
        if let subcategory = subcategory {
            self.title = "\(subcategory.category)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeResultsVC {
            vc.subcategoryDetail = sender as? SubcategoryModel
        }
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
        if let subcategory = subcategory {
            let selectedSubcategory = subcategory.names[indexPath.row]
            let index = subcategory.categoryData.index(forKey: selectedSubcategory)
            let subcategoryData = subcategory.categoryData[index!].value
            if let author = subcategoryData[Constants.SubcategoryData.author], let instagram = subcategoryData[Constants.SubcategoryData.instagram], let description = subcategoryData[Constants.SubcategoryData.description], let date = subcategoryData[Constants.SubcategoryData.date], let additionalInfo = subcategoryData[Constants.SubcategoryData.additionalInfo] {
                let subcategoryDetail = SubcategoryModel(author: author, instagram: instagram, description: description, date: date, additionalInfo: additionalInfo, category: subcategory.superCategory, subcategory: subcategory.category, photoId: selectedSubcategory)
                performSegue(withIdentifier: "ShowSubcategoryDetail", sender: subcategoryDetail)
            }
        }
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
