//
//  HomeCell.swift
//  MYouSeeEm
//
//  Created by Angel Onuoha on 3/1/20.
//  Copyright © 2020 MYouSeeEm. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

protocol HomeCellDelegate {
    func makeLoadingView(visible: Bool)
}

class HomeCell: UITableViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: HomeCellDelegate?
    
    override func awakeFromNib() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    var isArtistSpotlight: Bool {
        return artists.count > 0
    }
    
    // Category and subcategories = for categories
    var category: String? {
        didSet {
            prepare()
        }
    }
    var subcategories: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var artists: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func prepare() {
        categoryTitleLabel.text = category
        self.downloadSubcategoriesFromFirebase(category: category)
    }
    func downloadSubcategoriesFromFirebase(category: String?) {
        
        if let category = category {
            ref.child("Category/\(category)/").observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let keys = rest.key
                    if category == "Artist Spotlight" {
                        self.artists.append(keys)
                    } else {
                        self.subcategories.append(keys)
                    }
                }
                self.delegate?.makeLoadingView(visible: false)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    
}
extension HomeCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isArtistSpotlight {
            return artists.count
        } else {
            return subcategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isArtistSpotlight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBusinessCell", for: indexPath) as! HomeBusinessCell
            cell.artist = artists[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSubcategoryCell", for: indexPath) as! HomeSubcategoryCell
            cell.subcategory = subcategories[indexPath.row]
            return cell
        }
        
    }
    
    
}

extension HomeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 130, height: 130)
    }
}
