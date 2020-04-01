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
        downloadMuseumsFromFirebase()
        museumTextView.isScrollEnabled = false
        museumTextView.isEditable = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MuseumVC {
            vc.museumData = sender as? MuseumModel
        }
    }
}

extension MuseumsToVisit: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MuseumsToVisitViewCell", for: indexPath) as! MuseumsToVisitViewCell
        cell.subcategory = subcategories[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGeography = subcategories[indexPath.row]
        let museumSnapshot = categoryData.value as! [String: [String: [String: String]]]
        let index = museumSnapshot.index(forKey: selectedGeography)
        let museumData = MuseumModel(geography: selectedGeography, museums: museumSnapshot[index!].value)
        performSegue(withIdentifier: "ShowMuseums", sender: museumData)
    }
    
}

extension MuseumsToVisit: UICollectionViewDelegateFlowLayout {
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
