//
//  MuseumsToVisit.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/5/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MuseumsToVisit: UIViewController {
    @IBOutlet weak var geographyCollectionView: UICollectionView!
    @IBOutlet weak var museumTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var data: [Any]!
    var categoryData: DataSnapshot!
    var category: String?
    var subcategories: [String] = [] {
        didSet {
            geographyCollectionView.reloadData()
        }
    }
    
    func downloadMuseumsFromFirebase() {
        ref.child("Category/Museums to Visit/").observeSingleEvent(of: .value, with: { (snapshot) in
            self.data = snapshot.children.allObjects as [AnyObject]
            self.categoryData = snapshot
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let keys = rest.key
                self.subcategories.append(keys)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension MuseumsToVisit: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    
}
