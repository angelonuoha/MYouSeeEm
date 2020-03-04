//
//  HomeCategoryVC.swift
//  Zuvy
//
//  Created by Vladimir Fedorov on 14.12.2019.
//  Copyright © 2019 Zuvy. All rights reserved.
//

import UIKit

class HomeCategoryVC: UIViewController {

    @IBOutlet weak var topView: NavActionView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension HomeCategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)
        return cell
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
